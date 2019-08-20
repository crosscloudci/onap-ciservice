# encoding: UTF-8

require 'crosscloudci/ciservice/build_pipeline'
require 'crosscloudci/utils'
require 'jenkins_api_client'
require 'faraday'
require 'json'

module CrossCloudCi
  module CiService;
    module Onap
      class BuildPipeline < ::CrossCloudCi::CiService::BuildPipeline

        def container_image_tag(release_type=nil)
          case @release_type
          when "stable"
            stable_container_image_tag
          when "head","master","nightly","latest"
            head_container_image_tag
          else
            raise UnknownReleaseType.new(release_type)
          end
        end

        def stable_container_image_tag
          pipeline.project_config["stable_ref"]
        end

        def jenkins_daily_build_console_data
          base_console_log_url = "https://logs.onap.org/production/vex-yul-ecomp-jenkins-1/so-master-docker-version-java-daily/"

          job_id = build_job_id("head")

          console_log_url = "#{base_console_log_url}/#{job_id}/console.log.gz"

          response = nil
          tries=3
          begin
            @logger.debug "[ONAP Integration] calling Jenkins for #{@project_name}"
            response = Faraday.get console_log_url
          rescue Faraday::ConnectionFailed => e
            @logger.error "[ONAP Integration] Failed to connect to ONAP Jenkins server.  Error: #{e}"
            tries -= 1
            if tries > 0
              @logger.info "[ONAP Integration] Trying to call Jenkins again"
              retry
            else
              @logger.error "[ONAP Integration] Giving up trying to call Jenkins"
              # TODO: raise error
              return
            end
          end

          if response.body.nil?
            @logger.error "Failed to download last build data from #{url}"
            return
          end

          log_data = response.body
        end

        def head_container_image_tag
          # TODO: :arrow_forward:  Construct image_tag_name with the release version + "-STAGING-latest".  If the version ends in .0 then strip the.0 (edited)
          version = release_version
          version.sub!(/\.0$/,"")


          log_data = jenkins_daily_build_console_data
          tag_line = log_data.lines.grep(/Tag with/).grep(/openecomp\/mso:/).last
          line_parts = tag_line.split('with ')
          image_tag = line_parts[1].split(',')[0]
        end

        # TODO: fix tests
        def container_image_url(release_type=nil)
          case @release_type
          when "stable"
            stable_container_image_url
          when "head","master","nightly","latest"
            head_container_image_url
          else
            raise UnknownReleaseType.new(release_type)
          end
        end

        def stable_container_image_url
          project_config["container_image_url"] if project_config
        end

        def head_container_image_url
          project_config["container_image_url"] if project_config
        end

        def stable_container_image_tag
          ref =  project_config["stable_ref"]
          raise InvalidConfig.new("stable ref not set") unless ref
          ref
        end

        def release_version(release_type=nil)
          case @release_type
          when "stable"
            # NOT SUPPORTED
          when "head","master","nightly","latest"
            head_release_version
          else
            raise UnknownReleaseType.new(release_type)
          end
        end

        def head_release_version
          env_data = @env_data ||= environment_job_data
          envmap = env_data["envMap"]

          @logger.info "[Onap CiService] #{project_name} release #{envmap["release_version"]}" if envmap["release_version"]
          envmap["release_version"] if envmap["release_version"]
        end


        # # container artifact is the repostiory, image repo + name, and image tag
        # def stable_container_artifact_url
        #   image_url = stable_container_image_url
        #   tag = stable_container_image_tag
        #   "#{image_url}:#{tag}"
        # end


        def environment_job_url
          "#{build_job_url}/injectedEnvVars/api/json?pretty=false"
        end

        def environment_job_data
          url = environment_job_url

          response = nil
          tries=3
          begin
            @logger.debug "[ONAP Integration] calling Jenkins for #{@project_name}"
            response = Faraday.get url
          rescue Faraday::ConnectionFailed => e
            @logger.error "[ONAP Integration] Failed to connect to ONAP Jenkins server.  Error: #{e}"
            tries -= 1
            if tries > 0
              @logger.info "[ONAP Integration] Trying to call Jenkins again"
              retry
            else
              @logger.error "[ONAP Integration] Giving up trying to call Jenkins"
              # TODO: raise error
              return
            end
          end

          if response.body.nil?
            @logger.error "Failed to download last build data from #{url}"
            return
          end

          begin
            data = JSON.parse(response.body)
          rescue JSON::ParserError
            @logger.error "Failed to parse last build environment data from #{url}"
          end
          data
        end


        def build_job_id(release_type=nil)
          case @release_type
          when "stable"
            raise UnsupportedRelease.new("Release #{@release_type} is not supported for build_status")
          when "head","master","nightly","latest"
            head_build_job_id
          else
            raise UnknownReleaseType.new(release_type)
          end
        end


        def head_build_job_id
          build_data = @build_data ||= last_build
          job_id = build_data["id"] if build_data["id"]

          if numeric?(job_id)
            job_id.to_i
          else
            @logger.error "Job id is not a number! => #{job_id}"
            raise Error.new("Job id is not a number! => #{job_id}")
          end
        end


        def build_job_url(release_type=nil)
          case @release_type
          when "stable"
            raise UnsupportedRelease.new("Release #{@release_type} is not supported for build_status")
          when "head","master","nightly","latest"
            head_build_job_url
          else
            raise UnknownReleaseType.new(release_type)
          end
        end

        def head_build_job_url
          build_data = @build_data ||= last_build
          build_data["url"] if build_data["url"]
        end


        def build_status(release_type=nil)
          case @release_type
          when "stable"
            raise UnsupportedRelease.new("Release #{@release_type} is not supported for build_status")
          when "head","master","nightly","latest"
            head_build_status
          else
            raise UnknownReleaseType.new(release_type)
          end
        end

        def head_build_status
          build_data = @build_data ||= last_build
          build_data["result"].downcase if build_data["result"]
        end

        def last_build(release_type=nil)
          case @release_type
          when "stable"
            raise UnsupportedRelease.new("Release #{@release_type} is not supported for last_build")
          when "head","master","nightly","latest"
            last_head_build
          else
            raise UnknownReleaseType.new(release_type)
          end
        end

        def last_head_build
          #url = "https://jenkins.onap.org/view/Daily-Jobs/job/so-master-docker-version-java-daily/lastBuild/api/json?pretty=true"
          base_url = project_config["head_base_job_url"]

          url = "#{base_url}/lastBuild/api/json?pretty=false"
          response = Faraday.get url
          if response.body.nil?
            @logger.error "Failed to download last build data from #{url}"
            return
          end

          begin
            data = JSON.parse(response.body)
          rescue JSON::ParserError
            @logger.error "Failed to parse last build data from #{url}"
          end
          data
        end

        private

        def jenkins_connect

        end

        def numeric?(str)
          Float(str) != nil rescue false
        end



      end
    end
  end
end

