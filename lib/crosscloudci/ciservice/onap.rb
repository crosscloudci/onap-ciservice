# encoding: UTF-8

require 'crosscloudci/ciservice/onap/client'

module CrossCloudCi
  module CiService
    module Onap
      # Create a ONAP CiService client:
      #
      # A default client is created if options is omitted.
      def self.client(options = {})
        Client.new(options)
      end
    end
  end
end
