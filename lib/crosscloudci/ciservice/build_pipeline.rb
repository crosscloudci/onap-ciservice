# encoding: UTF-8

require 'crosscloudci/utils'
require 'crosscloudci/ciservice/container_registry'
require 'logger'
require 'byebug'

# Integrations
module CrossCloudCi
  module CiService
    def self.build_pipeline(options)
      case options[:integration]
      when "onap"
        require 'crosscloudci/ciservice/onap/build_pipeline'
        CrossCloudCi::CiService::Onap::BuildPipeline.new(options)
      else
        CrossCloudCi::CiService::BuildPipeline.new(options)
      end
    end
  end
end



module CrossCloudCi
  module CiService
    class BuildPipeline
      attr_accessor :cross_cloud_config, :project_name, :release_type
      attr_accessor :integration
      #attr_accessor :container_image_url, :container_registry, :image_name, :image_tag
      attr_accessor :container_registry, :image_name, :image_tag
      attr_accessor :build_data, :environment_job_data
      attr_accessor :artifact_service
      attr_accessor :logger

      class Error < StandardError ;  end
      class UnsupportedRelease < CrossCloudCi::CiService::BuildPipeline::Error; end
      class UnknownReleaseType < CrossCloudCi::CiService::BuildPipeline::Error; end
      class MissingProjectConfig < CrossCloudCi::CiService::BuildPipeline::Error; end
      class MissingContainerImageUrl < CrossCloudCi::CiService::BuildPipeline::Error; end
      class MissingContainerImageTag < CrossCloudCi::CiService::BuildPipeline::Error; end

      def initialize(options = {})
        @logger = Logger.new(STDOUT)
        @logger.level = Logger::WARN

        # TODO: Enforce required options
        #   - project_name
        #   - release-type
        #   - config_location
        @project_name = options[:project_name]
        @release_type = options[:release_type]
        @integration = options[:integration]
        @cross_cloud_config = CrossCloudCi::Utils.load_config(options[:config_location])

        raise MissingProjectConfig.new("Configuration not found for project #{project_name}") unless project_config

        # if self.class.name == "CrossCloudCi::CiService::BuildPipeline"
				# 	@logger.debug "only for integration"
				# 	puts "DEBUG: only for integration"
        #   # if @integration == "onap"
        #   #   #@integration_pipeline = CrossCloudCi::Onap::CiService::BuildPipeline.new(options)
        #   #   name = "CrossCloudCi::CiService::Onap::BuildPipeline"
        #   #   klass = name.split("::").inject(Object) { |k,n| k.const_get(n) }
        #   #   @integration_pipeline = klass.new(options)
        #   # end
				# 	#@integration_pipeline = Onap::BuildPipeline.new(options)
				# 	@integration_pipeline = ::CrossCloudCi::CiService::Onap::BuildPipeline.new(options)
        # end
      end

      # Docker container registry, repo and name
      # def container_image_url
      #   # TODO: Raise error if project not found
      #   @container_image_url = project_config["container_image_url"] if project_config
      # end

      # TODO: call container_image_url and container_image_tag
      #       combine results
      # def container_artifact_url
      # end
       
      def project_config
        @cross_cloud_config["projects"][@project_name]
      end

      def container_image_url(release_type=nil)
        # TODO: call integration class based on @integration name
        #
        #  eg. Module.const_get("CrossCloudCi::#{@integration}::BuildPipeline")
        if @integration_pipeline
          @integration_pipeline.container_image_url
        end
      end

      def container_image_tag 
        # TODO: call integration class based on @integration name
        #
        #  eg. Module.const_get("CrossCloudCi::#{@integration}::BuildPipeline")
        if @integration_pipeline
          @integration_pipeline.container_image_tag
        end
      end

      # TODO: switch to alias or include module
      def download_container(url=nil)
        if url.nil?

          url = container_artifact_url
        end

        @logger.info "[Onap BuildPipeline] container image url: #{url}"

        CrossCloudCi::CiService::ContainerRegistry.download_container(url)
      end

      def container_artifact_url
          image_url = container_image_url
          raise MissingContainerImageUrl.new("Container image url not found for project=#{@project_name} release=#{@release_type}") if image_url.nil?

          tag = container_image_tag

          url = (tag.nil?) ? image_url : "#{image_url}:#{tag}"
      end

      def create_pinning_config(file=nil)
        raise MissingContainerImageUrl.new("Valid container image [URL] needed for project") if container_image_url.nil?
        container_name = CrossCloudCi::CiService::ContainerRegistry.extract_image_name(container_image_url)
        # TODO: support creating a file based on given path and a temp file
        #<<-PINNING_CONFIG
        <<~PINNING_CONFIG
        export IMAGE_ARGS="--set image.repository=#{container_name}"
        export TAG_ARGS="--set image.tag=#{container_image_tag}"
        PINNING_CONFIG
      end


      def verify_container_artifact(url)
        CrossCloudCi::CiService::ContainerRegistry.verify_artifact(url)
      end
    end
  end
end

