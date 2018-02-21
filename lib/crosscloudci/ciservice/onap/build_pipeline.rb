# encoding: UTF-8

require 'crosscloudci/ciservice/build_pipeline'
require 'crosscloudci/utils'

module CrossCloudCi
  module CiService;
    module Onap
      class BuildPipeline < ::CrossCloudCi::CiService::BuildPipeline

        # TODO: check release logic
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

        def head_container_image_tag
          # TODO: pull image tag from Jenkins
          # TBD in 317
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

        def stable_container_image_tag
          ref =  project_config["stable_ref"]
          raise InvalidConfig.new("stable ref not set") unless ref
          ref
        end

        # # container artifact is the repostiory, image repo + name, and image tag
        # def stable_container_artifact_url
        #   image_url = stable_container_image_url
        #   tag = stable_container_image_tag
        #   "#{image_url}:#{tag}"
        # end
      end
    end
  end
end

