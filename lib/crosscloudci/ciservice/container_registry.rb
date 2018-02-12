# encoding: UTF-8

require 'docker_registry2'
require 'crosscloudci/ciservice/container_registry/client'

module CrossCloudCi
  module CiService
    module ContainerRegistry
      #TODO: add error/exception class

      class << self
        attr_accessor :registry_url, :connection, :registry_user, :registry_password
      end

      def self.client(options = {})
        Client.new(options)
      end

      # TODO: look into gitlab auth vs docker
      # gitlab auth is jwt and does not work the same as the docker registry
      # maybe switch to using docker command line

      ### https://docs.docker.com/registry/spec/api


      def self.connect(registry_url, opts = {})
        #NOTE: onap registry needs login
        @connection = DockerRegistry2.connect(registry_url, opts)
      end

      # try to pull a docker image down into a temporary path
      # optional hash args:
      #   path: <path_to_download_docker_image>
      #   delete: true  => deletes image after pulling it down
      #def self.docker_pull(image, opts = {})
      #end

      def self.verify_artifact(url, opts={})
        # TODO: handle connection.  Maybe:
        #   1. raise  error if @connection is not established
        #   2. create connection based on opts passed?

        url_parts = url.match("(?:([^:]*)://)?([^/]*)([^:]*)?:?(.*)?").to_a

        proto, hostport, namespacerepo, tag = url_parts.slice(1, url_parts.length)
        namespacerepo.sub!("/","")

        registry_url = "#{proto}://#{hostport}"
        opts = {user: 'docker', password: 'docker'}
#         reg = self.connect(registry_url, opts)

        
        pull_results = nil

        # # if opts[:delete] # only deleting for temp paths
          # Dir.mktmpdir do |dir|
          #   pull_results = reg.pull(namespacerepo, tag, dir)
          # end
        # elsif opts[:path]
        #   pull_results = reg.pull(namespacerepo, tag, opts[:path])
        # else
        #   pull_results = reg.pull(namespacerepo, tag, opts[:path])
        # end
        #
       
        image_url = "#{hostport}/#{namespacerepo}:#{tag}"

				pull_results = IO.popen(['docker', 'pull', image_url], in: :in) do |io|
				 io.read
				end

				raise 'docker pull failed' unless $?.success?

        pull_results
      end
    end
  end
end

