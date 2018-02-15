# encoding: UTF-8

require 'crosscloudci/utils'
require 'crosscloudci/ciservice/container_registry'
require 'byebug'

module CrossCloudCi
  module CiService
    class BuildPipeline
      attr_accessor :cross_cloud_config, :project_name
      attr_accessor :container_image_url, :container_registry, :image_name, :image_tag
      attr_accessor :artifact_service

      def initialize(options = {})
        @project_name = options[:project_name]
        @cross_cloud_config = CrossCloudCi::Utils.load_config(options[:config_location])

        @container_image_url = project_config["container_image_url"] if project_config
      end

      def project_config
        @cross_cloud_config["projects"][@project_name]
      end

      # TODO: switch to alias or include module
      def download_container(url)
        CrossCloudCi::CiService::ContainerRegistry.download_container(url)
      end

      def verify_container_artifact(url)
        CrossCloudCi::CiService::ContainerRegistry.verify_artifact(url)
      end
    end
  end
end

