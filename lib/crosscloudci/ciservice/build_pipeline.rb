# encoding: UTF-8

require 'crosscloudci/utils'
require 'crosscloudci/ciservice/container_registry'
require 'byebug'

# Integrations
require 'crosscloudci/onap/ciservice/build_pipeline'

module CrossCloudCi
  puts "CrossCloudCi before Ciservice (not onap) start"
  module CiService
  puts "CrossCloudCi Ciservice before build pipelines start"
    class BuildPipeline
      attr_accessor :cross_cloud_config, :project_name, :release_type
      attr_accessor :integration
      #attr_accessor :container_image_url, :container_registry, :image_name, :image_tag
      attr_accessor :container_registry, :image_name, :image_tag
      attr_accessor :artifact_service

      class Error < StandardError ;  end
      class UnknownReleaseType < CrossCloudCi::CiService::BuildPipeline::Error; end

      def initialize(options = {})
        # TODO: Enforce required options
        #   - project_name
        #   - release-type
        #   - config_location
        @project_name = options[:project_name]
        @release_type = options[:release_type]
        @integration = options[:integration]
        @cross_cloud_config = CrossCloudCi::Utils.load_config(options[:config_location])

        if @integration == "onap"
          #@integration_pipeline = CrossCloudCi::Onap::CiService::BuildPipeline.new(options)
          name = "CrossCloudCi::Onap::CiService::BuildPipeline"
          klass = name.split("::").inject(Object) { |k,n| k.const_get(n) }
          @integration_pipeline = klass.new(options)
        end
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

      def container_image_url 
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
          image_url = container_image_url

          # TODO: get tag
          tag = container_image_tag
          byebug
          url = "#{image_url}:#{tag}"
        end

        CrossCloudCi::CiService::ContainerRegistry.download_container(url)
      end

      def verify_container_artifact(url)
        CrossCloudCi::CiService::ContainerRegistry.verify_artifact(url)
      end
    end
  end
end

