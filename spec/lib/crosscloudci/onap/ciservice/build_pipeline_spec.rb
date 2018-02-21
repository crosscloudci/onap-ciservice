
# encoding: UTF-8

require 'crosscloudci/onap/ciservice/build_pipeline'
require 'webmock'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
end

describe CrossCloudCi::Onap::CiService::BuildPipeline do
  describe ".new" do
    it "has access to the cross-cloud config" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "onap-so"
      release_type = "stable"
      options = {config_location: config_location, project_name: project_name, release_type: release_type}

      pipeline = CrossCloudCi::Onap::CiService::BuildPipeline.new(options)
      expect(pipeline).to be_a(CrossCloudCi::Onap::CiService::BuildPipeline)
      expect(pipeline).to be_a(CrossCloudCi::CiService::BuildPipeline)
      expect(pipeline.cross_cloud_config).to be_truthy
    end
  end

  describe ".container_image_tag" do
    it "returns an stable image tag when release is stable for the onap so project" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "onap-so"
      release_type = "stable"
      options = {config_location: config_location, project_name: project_name, release_type: release_type}

      pipeline = CrossCloudCi::Onap::CiService::BuildPipeline.new(options)

      #container_image_url = "https://nexus3.onap.org:10001/openecomp/mso"
      image_tag = "v1.1.1"
      #container_artifact_url = "#{container_image_url}:#{image_tag}"

      expect(pipeline.container_image_tag).to eq(image_tag)
    end

    xit "returns an head image tag when release is head for the onap so project" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "onap-so"
      release_type = "head"
      options = {config_location: config_location, project_name: project_name, release_type: release_type}

      pipeline = CrossCloudCi::Onap::CiService::BuildPipeline.new(options)

      #container_image_url = "https://nexus3.onap.org:10001/openecomp/mso"
      image_tag = "v1.1.1"
      #container_artifact_url = "#{container_image_url}:#{image_tag}"

      expect(pipeline.container_image_tag).to eq(image_tag)
    end
  end

  describe ".stable_container_image_tag" do
    it "returns an stable image tag for the onap so project" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "onap-so"
      release_type = "stable"
      options = {config_location: config_location, project_name: project_name, release_type: release_type}

      pipeline = CrossCloudCi::Onap::CiService::BuildPipeline.new(options)

      #container_image_url = "https://nexus3.onap.org:10001/openecomp/mso"
      image_tag = "v1.1.1"
      #container_artifact_url = "#{container_image_url}:#{image_tag}"

      expect(pipeline.container_image_tag).to eq(image_tag)
    end
  end

  describe ".head_container_image_tag" do
    xit "returns an head image tag for the onap so project" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "onap-so"
      release_type = "head"
      options = {config_location: config_location, project_name: project_name, release_type: release_type}

      pipeline = CrossCloudCi::Onap::CiService::BuildPipeline.new(options)

      #container_image_url = "https://nexus3.onap.org:10001/openecomp/mso"
      image_tag = "v1.1.1"
      #container_artifact_url = "#{container_image_url}:#{image_tag}"

      expect(pipeline.container_image_tag).to eq(image_tag)
    end
  end



  describe ".container_artifact_url" do
    xit "builds a container url based on release type given" do
      # test container_artifact_url
    end

    it "builds a container url based on the container image url and the ref for stable releases" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "onap-so"
      release_type = "stable"
      options = {config_location: config_location, project_name: project_name, release_type: release_type}

      pipeline = CrossCloudCi::Onap::CiService::BuildPipeline.new(options)
      expect(pipeline).to be_a(CrossCloudCi::CiService::BuildPipeline)

      container_image_url = "https://nexus3.onap.org:10001/openecomp/mso"
      image_tag = "v1.1.1"
      container_artifact_url = "#{container_image_url}:#{image_tag}"

      expect(pipeline.stable_container_artifact_url).to eq(container_artifact_url)
    end

    it "builds a container url based on the container image url and jenkins master/nightly release" do
    end
  end

  describe ".download_container" do
    # NOTE: ONAP SO is > 1.5GB
    it "can sucessfully download container specified as method argument from onap container registry" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "onap-so"
      release_type = "stable"
      options = {config_location: config_location, project_name: project_name, release_type: release_type}

      container_image_url = "https://nexus3.onap.org:10001/openecomp/mso"
      image_tag = "v1.1.1"
      container_artifact_url = "#{container_image_url}:#{image_tag}"

      #pipeline = CrossCloudCi::CiService::BuildPipeline.new(options)
      pipeline = CrossCloudCi::Onap::CiService::BuildPipeline.new(options)
      expect(pipeline.download_container(container_artifact_url)).to be_truthy
    end

    it "can download the stable docker container as found dynamically in the configuration" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "onap-so"
      release_type = "stable"
      options = {config_location: config_location, project_name: project_name, release_type: release_type}

      # container_image_url = "https://nexus3.onap.org:10001/openecomp/mso"
      # image_tag = "v1.1.1"
      # container_artifact_url = "#{container_image_url}:#{image_tag}"

      #pipeline = CrossCloudCi::CiService::BuildPipeline.new(options)
      pipeline = CrossCloudCi::Onap::CiService::BuildPipeline.new(options)
      expect(pipeline.download_container).to be_truthy
    end

  end

  # xdescribe ".verify_container_artifact" do
  #   # NOTE: ONAP SO is > 1.5GB
  #   xit "can sucessfully run a test on the downloaded container artifact from onap container registry" do
  #     config_location = "spec/test-cross-cloud.yml"
  #     project_name = "onap-so"
  #     options = {config_location: config_location, project_name: project_name}
  #
  #     container_image_url = "https://nexus3.onap.org:10001/openecomp/mso"
  #     image_tag = "v1.1.1"
  #     container_artifact_url = "#{container_image_url}:#{image_tag}"
  #
  #     pipeline = CrossCloudCi::CiService::BuildPipeline.new(options)
  #     expect(pipeline.verify_container_artifact(container_artifact_url)).to be_truthy
  #
  #   end
  # end
end
