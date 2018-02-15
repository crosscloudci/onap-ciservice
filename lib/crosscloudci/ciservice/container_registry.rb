# encoding: UTF-8

require 'docker_registry2'
require 'crosscloudci/ciservice/container_registry/client'

module CrossCloudCi
  module CiService
    module ContainerRegistry
      #TODO: add error/exception class
      class Error < StandardError ;  end
      class ContainerVerifyError < CrossCloudCi::CiService::ContainerRegistry::Error; end
      class ContainerDownloadError < CrossCloudCi::CiService::ContainerRegistry::Error; end

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

      ## Purpose: Verify that the docker container given is accessible and downloads successfully
      # def self.verify_artifact(path, opts={})
      #   # Verify local container
        #raise ContainerVerifyError, "Container::Registry: problem with container from #{path}" unless $?.success?
      # end
      # def self.verify_artifact(url, opts={})
      #   # TODO: handle connection.  Maybe:
      #   #   1. raise  error if @connection is not established
      #   #   2. create connection based on opts passed?
      #
      #   download_container(url)
      #   # if opts[:delete]
      #   #   delete_local_artifact(url)
      #   # end
        #raise ContainerVerifyError, "Container::Registry: problem with container from #{image_url}" unless $?.success?
      #
      #  # TODO: use docker run on container to run tests
      # end

      # def self.install_container(url, opts={})
      #   download_container(url, opts)
      #   verify_container(url, opts)
      # end

      def self.download_container(url, opts={})
        # TODO: handle connection.  Maybe:
        #   1. raise  error if @connection is not established
        #   2. create connection based on opts passed?

        # url_parts = url.match("(?:([^:]*)://)?([^/]*)([^:]*)?:?(.*)?").to_a
        #
        # proto, hostport, namespacerepo, tag = url_parts.slice(1, url_parts.length)
        # namespacerepo.sub!("/","")

        #registry_url = "#{proto}://#{hostport}"
        #opts = {user: 'docker', password: 'docker'}
#         reg = self.connect(registry_url, opts)

        #pull_results = nil

        # # if opts[:delete] # only deleting for temp paths
          # Dir.mktmpdir do |dir|
          #   pull_results = reg.pull(namespacerepo, tag, dir)
          # end
        # elsif opts[:path]
        #   pull_results = reg.pull(namespacerepo, tag, opts[:path])
        # else
        #   pull_results = reg.pull(namespacerepo, tag, opts[:path])
        # end
       
        image_url = extract_image_url(url)

        # TODO: capture exit code and stderr
				pull_results = IO.popen(['docker', 'pull', image_url], in: :in) do |io|
				 io.read
				end

        raise ContainerDownloadError, "Container::Registry: docker pull failed for #{image_url}" unless $?.success?
        pull_results
      end

      def self.delete_local_artifact(url, opts={})
        image_url = extract_image_url(url)
        puts "deleting #{image_url}"
				results = IO.popen(['docker', 'image', 'rm', image_url], in: :in) do |io|
				 io.read
				end

        #raise ContainerVerifyError, "Container::Registry: docker pull failed for #{image_url}" unless $?.success?
        $?.success?
      end

      def self.extract_image_url(url)
        url_parts = url.match("(?:([^:]*)://)?([^/]*)([^:]*)?:?(.*)?").to_a

        proto, hostport, namespacerepo, tag = url_parts.slice(1, url_parts.length)
        namespacerepo.sub!("/","")

        "#{hostport}/#{namespacerepo}:#{tag}"
      end 
    end # ContainerRegistry
  end # CiService
end # CrossCloudCi

