require 'faraday'
require 'yaml'
require 'uri'

module CrossCloudCi
  module Utils
    class Error < StandardError ;  end
    class InvalidConfig < CrossCloudCi::Utils::Error; end
    class ConfigLoadError < CrossCloudCi::Utils::Error; end
    class UnknownReleaseType < CrossCloudCi::Utils::Error; end

    @config_path = "config/cross-cloud.yml"

    class << self; attr_accessor :config_path; end

    def self.load_config(s=nil)
      if s
        uri = URI.parse(s)
        if %w( http https ).include?(uri.scheme)
          return self.load_remote_config(s)
        else
          config_path = s
        end
      else
        config_path = @config_path
      end
      self.load_local_config(config_path)
    end

    def self.load_local_config(path)
      File.exists?(path)
      YAML.parse_file(path).to_ruby
    end

    def self.load_remote_config(url)
      if url.nil?
        raise ArgumentError.new("URL for cross-cloud.yml required")
      end

      response = Faraday.get url
      return response unless response

      YAML.parse(response.body).to_ruby
    end
  end
end
 
