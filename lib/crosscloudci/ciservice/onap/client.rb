# encoding: UTF-8

module CrossCloudCi
  module CiService
    module Onap
      class Client
        attr_accessor :cross_cloud_config
        def initialize(options = {})
          @cross_cloud_config = options[:cross_cloud_config]
        end
      end
    end
  end
end

