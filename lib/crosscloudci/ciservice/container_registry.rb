# encoding: UTF-8

require 'docker_registry2'
require 'crosscloudci/ciservice/container_registry/client'

module CrossCloudCi
  module CiService
    module ContainerRegistry
      class << self
        attr_accessor :registry_url
      end

      def self.client(options = {})
        Client.new(options)
      end

      def self.connect(registry_url, opts = {})
        DockerRegistry2.connect(registry_url, opts)
      end

      def self.verify_artifact(url)
        url_parts = url.match("([^:]*)://([^/]*)([^:]*)?:?(.*)?").to_a

        proto, hostport, namespacerepo, tag = url_parts.slice(1, url_parts.length)

        registry_url = "#{proto}://#{hostport}"
        reg = self.connect(registry_url)

        pull_results = nil

        Dir.mktmpdir do |dir|
          pull_results = reg.pull(namespacerepo, tag, dir)
        end

        pull_results
      end
    end
  end
end

