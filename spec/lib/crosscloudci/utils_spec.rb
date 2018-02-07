# encoding: UTF-8

require 'crosscloudci/utils'
require 'yaml'

describe CrossCloudCi::Utils do
  describe '.load_config' do
    it 'defaults to local config' do
      CrossCloudCi::Utils.config_path = "spec/test-cross-cloud.yml"
      
      config = CrossCloudCi::Utils.load_config

      expect(config).to be_truthy
      expect(config.class).to be_kind_of(YAML.class)
    end

    it 'supports url' do
      config_url = "https://raw.githubusercontent.com/crosscloudci/cncf-configuration/master/cross-cloud.yml"
      config = CrossCloudCi::Utils.load_config(config_url)

      expect(config).to be_truthy
      expect(config.class).to be_kind_of(YAML.class)
    end

    it 'supports path' do
      config_path = "spec/test-cross-cloud.yml"
      config = CrossCloudCi::Utils.load_config(config_path)

      expect(config).to be_truthy
      expect(config.class).to be_kind_of(YAML.class)
    end
  end

  describe '.load_remote_config' do
    it 'return a parsed cross-cloud.yml configuration' do
      config_url = "https://raw.githubusercontent.com/crosscloudci/cncf-configuration/master/cross-cloud.yml"
      config = CrossCloudCi::Utils.load_remote_config(config_url)

      expect(config).to be_truthy
      expect(config.class).to be_kind_of(YAML.class)
    end
  end
end
