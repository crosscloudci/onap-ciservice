# encoding: UTF-8

require 'crosscloudci/ciservice/build_pipeline'

describe CrossCloudCi::CiService::BuildPipeline do
  describe '.new' do
    it 'it loads the cross-cloud.yml config and sets project_name' do
      #config_location = "https://raw.githubusercontent.com/crosscloudci/cncf-configuration/master/cross-cloud.yml"
      config_location = "spec/test-cross-cloud.yml"
      project_name = "onap-mso"
      options = {config_location: config_location, project_name: project_name}

      pipeline = CrossCloudCi::CiService::BuildPipeline.new(options)
      expect(pipeline).to be_a(CrossCloudCi::CiService::BuildPipeline)
      expect(pipeline.cross_cloud_config).to be_truthy
    end
  end

  describe ".project_config" do
    it "returns the project specific config from cross-cloud.yml" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "onap-mso"
      options = {config_location: config_location, project_name: project_name}

      pipeline = CrossCloudCi::CiService::BuildPipeline.new(options)
      expect(pipeline).to be_a(CrossCloudCi::CiService::BuildPipeline)
      expect(pipeline.project_config).to be_truthy
      expect(pipeline.project_config["gitlab_name"]).to eq("onap")
    end
  end

  describe ".verify_container_artifact" do
    xit "can sucessfully do a docker pull on a valid container artifact" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "onap-mso"
      options = {config_location: config_location, project_name: project_name}

      container_image_url = "https://nexus3.onap.org:10001/openecomp/mso"
      image_tag = "v1.1.1"
      container_artifact_url = "#{container_image_url}:#{image_tag}"

      pipeline = CrossCloudCi::CiService::BuildPipeline.new(options)
      expect(pipeline.verify_container_artifact(container_artifact_url)).to be_truthy

    end
  end

  describe ".create_artifact_pinnings" do
    xit "Creates an artifact pinnings configuration" do
    end
  end
end
