
# encoding: UTF-8

require 'crosscloudci/ciservice/onap/build_pipeline'
require 'webmock'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
end

describe CrossCloudCi::CiService::Onap::BuildPipeline do
  describe ".new" do
    it "has access to the cross-cloud config" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "so"
      release_type = "stable"
      options = {config_location: config_location, project_name: project_name, release_type: release_type}

      pipeline = CrossCloudCi::CiService::Onap::BuildPipeline.new(options)
      expect(pipeline).to be_a(CrossCloudCi::CiService::Onap::BuildPipeline)
      expect(pipeline).to be_a(CrossCloudCi::CiService::BuildPipeline)
      expect(pipeline.cross_cloud_config).to be_truthy
    end
  end

  describe ".container_image_tag" do
    it "returns an stable image tag when release is stable for the onap so project" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "so"
      release_type = "stable"
      options = {config_location: config_location, project_name: project_name, release_type: release_type}

      pipeline = CrossCloudCi::CiService::Onap::BuildPipeline.new(options)

      #container_image_url = "https://nexus3.onap.org:10001/openecomp/mso"
      image_tag = "v1.1.1"
      #container_artifact_url = "#{container_image_url}:#{image_tag}"

      expect(pipeline.container_image_tag).to eq(image_tag)
    end

    it "returns an head image tag when release is head for the onap so project" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "so"
      release_type = "head"
      options = {config_location: config_location, project_name: project_name, release_type: release_type}

      pipeline = CrossCloudCi::CiService::Onap::BuildPipeline.new(options)

      #image_tag = "1.2.0-STAGING-latest"
      #image_tag = "1.2.0-STAGING-latest"
      image_tag_postfix = "-STAGING-latest"

      
      container_image_tag = pipeline.container_image_tag

      expect(container_image_tag).to  be_truthy
      expect(container_image_tag).to  including(image_tag_postfix)
    end
  end

  describe ".stable_container_image_tag" do
    it "returns an stable image tag for the onap so project" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "so"
      release_type = "stable"
      options = {config_location: config_location, project_name: project_name, release_type: release_type}

      pipeline = CrossCloudCi::CiService::Onap::BuildPipeline.new(options)

      #container_image_url = "https://nexus3.onap.org:10001/openecomp/mso"
      image_tag = "v1.1.1"
      #container_artifact_url = "#{container_image_url}:#{image_tag}"

      expect(pipeline.container_image_tag).to eq(image_tag)
    end
  end

  describe ".head_container_image_tag" do
    it "returns an head image tag for the onap so project" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "so"
      release_type = "head"
      options = {config_location: config_location, project_name: project_name, release_type: release_type}

      pipeline = CrossCloudCi::CiService::Onap::BuildPipeline.new(options)

      #image_tag = "1.2.0-STAGING-latest"
      image_tag_postfix = "-STAGING-latest"

      container_image_tag = pipeline.container_image_tag

      expect(container_image_tag).to  be_truthy
      expect(container_image_tag).to  including(image_tag_postfix)

    end
  end



  describe ".container_artifact_url from onap integration" do
    it "builds a container url based on the container image url and the ref for stable releases" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "so"
      release_type = "stable"
      options = {config_location: config_location, project_name: project_name, release_type: release_type}

      pipeline = CrossCloudCi::CiService::Onap::BuildPipeline.new(options)
      expect(pipeline).to be_a(CrossCloudCi::CiService::BuildPipeline)

      container_image_url = "https://nexus3.onap.org:10001/openecomp/mso"
      image_tag = "v1.1.1"
      container_artifact_url = "#{container_image_url}:#{image_tag}"

      expect(pipeline.container_artifact_url).to eq(container_artifact_url)
    end

    it "builds a container url based on the container image url and jenkins master/nightly release" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "so"
      release_type = "head"
      options = {config_location: config_location, project_name: project_name, release_type: release_type}

      pipeline = CrossCloudCi::CiService::Onap::BuildPipeline.new(options)
      expect(pipeline).to be_a(CrossCloudCi::CiService::BuildPipeline)

      container_image_url = "https://nexus3.onap.org:10001/openecomp/mso"
      image_tag_postfix = "-STAGING-latest"

      # version = pipeline.release_version
      # image_tag = "#{version}#{image_tag_postfix}"
      #image_tag = pipeline.container_image_tag

      # image_tag = "1.1.1"
      # container_artifact_url = "#{container_image_url}:#{image_tag}"

      # NOTE: Requires exact match with dynamic data
      #expect(pipeline.container_artifact_url).to eq(container_artifact_url)

      # TODO: some check for version in tag?
      expect(pipeline.container_artifact_url).to include(container_image_url)
      expect(pipeline.container_artifact_url).to include(image_tag_postfix)

    end
  end

  describe ".download_container" do
    # NOTE: ONAP SO is > 1.5GB
    it "can sucessfully download container specified as method argument from onap container registry" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "so"
      release_type = "stable"
      options = {config_location: config_location, project_name: project_name, release_type: release_type}

      container_image_url = "https://nexus3.onap.org:10001/openecomp/mso"
      image_tag = "v1.1.1"
      container_artifact_url = "#{container_image_url}:#{image_tag}"

      #pipeline = CrossCloudCi::CiService::BuildPipeline.new(options)
      pipeline = CrossCloudCi::CiService::Onap::BuildPipeline.new(options)
      expect(pipeline.download_container(container_artifact_url)).to be_truthy
    end

    it "can download the stable docker container as found dynamically in the configuration" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "so"
      release_type = "stable"
      options = {config_location: config_location, project_name: project_name, release_type: release_type}

      # container_image_url = "https://nexus3.onap.org:10001/openecomp/mso"
      # image_tag = "v1.1.1"
      # container_artifact_url = "#{container_image_url}:#{image_tag}"

      #pipeline = CrossCloudCi::CiService::BuildPipeline.new(options)
      pipeline = CrossCloudCi::CiService::Onap::BuildPipeline.new(options)
      expect(pipeline.download_container).to be_truthy
    end

    it "can download the head docker container as found dynamically in the configuration" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "so"
      release_type = "head"
      options = {config_location: config_location, project_name: project_name, release_type: release_type}

      # container_image_url = "https://nexus3.onap.org:10001/openecomp/mso"
      # image_tag = "v1.1.1"
      # container_artifact_url = "#{container_image_url}:#{image_tag}"

      #pipeline = CrossCloudCi::CiService::BuildPipeline.new(options)
      pipeline = CrossCloudCi::CiService::Onap::BuildPipeline.new(options)
      expect(pipeline.download_container).to be_truthy
    end
  end

  describe ".create_pinning_config" do
    it "create a pinning configuration for the onap so project build artifacts" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "so"
      release_type = "stable"
      options = {config_location: config_location, project_name: project_name, release_type: release_type, integration: "onap"}

      container_image_and_registry = "nexus3.onap.org:10001/openecomp/mso"
      # container_image_url = "https://nexus3.onap.org:10001/openecomp/mso"
      # image_tag = "v1.1.1"
      # container_artifact_url = "#{container_image_url}:#{image_tag}"

      #pipeline = CrossCloudCi::CiService::BuildPipeline.new(options)
      #pipeline = CrossCloudCi::CiService::Onap::BuildPipeline.new(options)
      pipeline = CrossCloudCi::CiService.build_pipeline(options)
      pinning_config = pipeline.create_pinning_config
      expect(pinning_config).to be_truthy
      expect(pinning_config).to include("export IMAGE_ARGS=\"--set image.repository=#{container_image_and_registry}")
    end
  end

  describe ".last_head_build" do
    it "retrieves the last \"head\" build for onap from jenkins" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "so"
      release_type = "stable"
      options = {config_location: config_location, project_name: project_name, release_type: release_type, integration: "onap"}

      pipeline = CrossCloudCi::CiService.build_pipeline(options)
      build_data = pipeline.last_head_build
      expect(build_data).to be_truthy
      expect(build_data["url"]).to include("https://jenkins.onap.org/view/Daily-Jobs/job/so-master-docker-version-java-daily")
    end
  end

  describe ".last_build" do
    let(:daily_job_base_url) { "https://jenkins.onap.org/view/Daily-Jobs/job" }
    it "retrieves build data for head" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "so"
      release_type = "head"
      options = {config_location: config_location, project_name: project_name, release_type: release_type, integration: "onap"}

      pipeline = CrossCloudCi::CiService.build_pipeline(options)
      build_data = pipeline.last_build
      expect(build_data).to be_truthy
      expect(build_data["url"]).to include("#{daily_job_base_url}/so-master-docker-version-java-daily")
    end
  end

  describe ".build_status" do
    it "retrieves last build status for head" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "so"
      release_type = "head"
      options = {config_location: config_location, project_name: project_name, release_type: release_type, integration: "onap"}

      pipeline = CrossCloudCi::CiService.build_pipeline(options)
      status = pipeline.build_status
      expect(status).to be_truthy
      expect(status).to be_a(String)
      #expect(status).to include("success")
    end
  end


  describe ".build_job_id" do
    it "retrieves last build job id for head" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "so"
      release_type = "head"
      options = {config_location: config_location, project_name: project_name, release_type: release_type, integration: "onap"}

      pipeline = CrossCloudCi::CiService.build_pipeline(options)
      job_id = pipeline.build_job_id
      expect(job_id).to be_truthy
      expect(job_id).to be_a(Numeric)
    end
  end

  describe ".build_job_url" do
    let(:daily_job_base_url) { "https://jenkins.onap.org/view/Daily-Jobs/job" }

    it "retrieves last build job url for head" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "so"
      release_type = "head"
      options = {config_location: config_location, project_name: project_name, release_type: release_type, integration: "onap"}

      pipeline = CrossCloudCi::CiService.build_pipeline(options)
      job_url = pipeline.build_job_url
      expect(job_url).to be_truthy
      #expect(job_id).to include("https://jenkins.onap.org/view/Daily-Jobs/job/so-master-docker-version-java-daily")
      expect(job_url).to include(daily_job_base_url)
    end
  end


  describe ".environment_job_url" do
    it "contstructs a enviroment url based on the retrieved job url for head" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "so"
      release_type = "head"
      options = {config_location: config_location, project_name: project_name, release_type: release_type, integration: "onap"}

      pipeline = CrossCloudCi::CiService.build_pipeline(options)
      job_url = pipeline.environment_job_url
      expect(job_url).to be_truthy
      #expect(job_id).to include("https://jenkins.onap.org/view/Daily-Jobs/job/so-master-docker-version-java-daily")
      #expect(job_url).to include("https://jenkins.onap.org/view/daily-jobs/job")
      expect(job_url).to include("injectedEnvVars/api/json")
    end
  end

  describe ".release_version" do
    it "contstructs a enviroment url based on the retrieved job url for head" do
      config_location = "spec/test-cross-cloud.yml"
      project_name = "so"
      release_type = "head"
      options = {config_location: config_location, project_name: project_name, release_type: release_type, integration: "onap"}

      pipeline = CrossCloudCi::CiService.build_pipeline(options)
      release_version = pipeline.release_version
      expect(release_version).to be_truthy
      #expect(job_id).to include("https://jenkins.onap.org/view/Daily-Jobs/job/so-master-docker-version-java-daily")
      #expect(job_url).to include("https://jenkins.onap.org/view/daily-jobs/job")
      #expect(release_version).to include("?")
    end
  end


  # xdescribe ".verify_container_artifact" do
  #   # NOTE: ONAP SO is > 1.5GB
  #   xit "can sucessfully run a test on the downloaded container artifact from onap container registry" do
  #     config_location = "spec/test-cross-cloud.yml"
  #     project_name = "so"
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
