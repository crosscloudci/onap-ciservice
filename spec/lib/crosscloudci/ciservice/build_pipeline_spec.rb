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
    it "can sucessfully do a docker pull on a valid container artifact from docker hub registry" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "busybox"
      options = {config_location: config_location, project_name: project_name}

      container_image_url = "registry.hub.docker.com/library/busybox"
      image_tag = "latest"
      container_artifact_url = "#{container_image_url}:#{image_tag}"

      pipeline = CrossCloudCi::CiService::BuildPipeline.new(options)
      expect(pipeline.verify_container_artifact(container_artifact_url)).to be_truthy

    end


    it "can sucessfully do a docker pull on a valid container artifact from the Cross-Cloud container registry" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "coredns"
      options = {config_location: config_location, project_name: project_name}

      #container_image_url = "https://registry.cncf.ci/coredns/coredns"
      container_image_url = "https://registry.cncf.ci/coredns/coredns"
      image_tag = "master.f636930c.48550"
      #container_artifact_url = "#{container_image_url}:#{image_tag}"
      container_artifact_url = "https://registry.cncf.ci/coredns/coredns:master.f636930c.48550"

      pipeline = CrossCloudCi::CiService::BuildPipeline.new(options)
      expect(pipeline.verify_container_artifact(container_artifact_url)).to be_truthy

    end

    # TODO: move this to onap area?
    it "can sucessfully do a docker pull on a valid container artifact from onap container registry" do
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
