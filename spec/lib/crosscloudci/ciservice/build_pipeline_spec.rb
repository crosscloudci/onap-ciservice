# encoding: UTF-8

require 'crosscloudci/ciservice/build_pipeline'

describe CrossCloudCi::CiService::BuildPipeline do
  describe '.new' do
    it 'it loads the cross-cloud.yml config and sets project_name' do
      #config_location = "https://raw.githubusercontent.com/crosscloudci/cncf-configuration/master/cross-cloud.yml"
      config_location = "spec/test-cross-cloud.yml"
      project_name = "onap-so"
      options = {config_location: config_location, project_name: project_name, release_type: "stable"}

      pipeline = CrossCloudCi::CiService::BuildPipeline.new(options)
      expect(pipeline).to be_a(CrossCloudCi::CiService::BuildPipeline)
      expect(pipeline.cross_cloud_config).to be_truthy
      expect(pipeline.project_name).to be_truthy
      expect(pipeline.release_type).to be_truthy
    end
  end

  describe ".project_config" do
    it "returns the project specific config from cross-cloud.yml" do
      config_location = "spec/test-cross-cloud.yml"
      #project_name = "onap-so"
      project_name = "kubernetes"
      options = {config_location: config_location, project_name: project_name, "release-type": "stable"}

      pipeline = CrossCloudCi::CiService::BuildPipeline.new(options)
      expect(pipeline).to be_a(CrossCloudCi::CiService::BuildPipeline)
      expect(pipeline.project_config).to be_truthy
      expect(pipeline.project_config["gitlab_name"]).to eq("Kubernetes")
    end
  end

  # xdescribe ".verify_container_artifact" do
  #   xit "can sucessfully do a docker pull on a valid container artifact from docker hub registry" do
  #     config_location = "spec/test-cross-cloud.yml"
  #     project_name = "busybox"
  #     options = {config_location: config_location, project_name: project_name}
  #
  #     container_image_url = "registry.hub.docker.com/library/busybox"
  #     image_tag = "latest"
  #     container_artifact_url = "#{container_image_url}:#{image_tag}"
  #
  #     pipeline = CrossCloudCi::CiService::BuildPipeline.new(options)
  #     expect(pipeline.verify_container_artifact(container_artifact_url)).to be_truthy
  #   end
  # end

  describe ".download_container" do
    it "can sucessfully download a docker container specified as an argument" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "busybox"
      options = {config_location: config_location, project_name: project_name, "release-type": "stable"}

      container_image_url = "registry.hub.docker.com/library/busybox"
      image_tag = "latest"
      container_artifact_url = "#{container_image_url}:#{image_tag}"

      pipeline = CrossCloudCi::CiService::BuildPipeline.new(options)
      expect(pipeline.download_container(container_artifact_url)).to be_truthy
    end

    # TODO: decide if this should be here or in some other test file
    # INTEGRATION TEST
    it "can sucessfully download a docker container dynamically found for project with an integration" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "onap-so"
      release_type = "stable"
      integration = "onap"
      options = {config_location: config_location, project_name: project_name, release_type: release_type, integration: integration}

      # container_image_url = "registry.hub.docker.com/library/busybox"
      # image_tag = "latest"
      # container_artifact_url = "#{container_image_url}:#{image_tag}"

      pipeline = CrossCloudCi::CiService::BuildPipeline.new(options)
      expect(pipeline.download_container).to be_truthy
    end

  end

  describe ".create_artifact_pinnings" do
    xit "Creates an artifact pinnings configuration" do
    end
  end
end
