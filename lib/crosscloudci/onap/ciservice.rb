# encoding: UTF-8

require 'crosscloudci/onap/ciservice/client'

module CrossCloudCi
  module Onap
    module CiService
      # Create a ONAP CiService client:
      #
      # A default client is created if options is omitted.
      def self.client(options = {})
        Client.new(options)
      end
    end
  end
end
