# encoding: UTF-8

#  uninitialized constant CrossCloudCi::Onap::CiService::BuildPipeline

require 'crosscloudci/ciservice/build_pipeline'
require 'crosscloudci/utils'

module CrossCloudCi
  module Onap
    module CiService
      class BuildPipeline < CrossCloudCi::CiService::BuildPipeline

        def container_artifact_url(release_type)
          case release_type
          when :stable
            stable_container_artifact_url
          when :head,:master,:nightly,:latest
            head_container_artifact_url
          else
            raise UnknownReleaseType.new(release_type)
          end
        end

        def stable_container_artifact_url
          ref =  project_config["stable_ref"]
          if ref
            "#{container_image_url}:#{ref}"
          else
            raise InvalidConfig.new("stable ref not set")
          end
        end
      end
    end
  end
end
 
