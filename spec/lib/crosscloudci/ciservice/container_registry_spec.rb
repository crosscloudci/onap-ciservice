# encoding: UTF-8

require 'crosscloudci/ciservice/container_registry'

describe CrossCloudCi::CiService::ContainerRegistry do
  describe ".download_container" do
    it "can sucessfully do a download a container from docker hub registry" do
      container_image_url = "registry.hub.docker.com/library/busybox"
      image_tag = "latest"
      container_artifact_url = "#{container_image_url}:#{image_tag}"

      expect(CrossCloudCi::CiService::ContainerRegistry.download_container(container_artifact_url)
).to be_truthy
    end

    it "can sucessfully download a container from the Cross-Cloud container registry" do
      #container_image_url = "https://registry.cncf.ci/coredns/coredns"
      container_image_url = "https://registry.cncf.ci/coredns/coredns"
      image_tag = "master.f636930c.48550"
      container_artifact_url = "#{container_image_url}:#{image_tag}"
      #container_artifact_url = "https://registry.cncf.ci/coredns/coredns:master.f636930c.48550"
      expect(CrossCloudCi::CiService::ContainerRegistry.download_container(container_artifact_url)).to be_truthy
    end

    it "can raises an error when docker pull fails to download a container from the registry" do
      container_image_url = "registry.hub.docker.com/library/busybox"
      image_tag = "NOT_A_VALID_TAG"
      container_artifact_url = "#{container_image_url}:#{image_tag}"

      expect{
        CrossCloudCi::CiService::ContainerRegistry.download_container(container_artifact_url)
      }.to raise_error(CrossCloudCi::CiService::ContainerRegistry::ContainerDownloadError)
    end


  end

  # xdescribe ".verify_artifact" do
  #   xit "can sucessfully run verification tests on a downloaded container from docker hub registry" do
  #     container_image_url = "registry.hub.docker.com/library/busybox"
  #     image_tag = "latest"
  #     container_artifact_url = "#{container_image_url}:#{image_tag}"
  #     verification_opts = {cmd: "ls", cmd_opts: ""}
  #
  #     #expect(CrossCloudCi::CiService::ContainerRegistry.verify_artifact(container_artifact_url)).to be_truthy
  #     expect(CrossCloudCi::CiService::ContainerRegistry.verify_artifact(container_artifact_url, verification_opts)).to be_truthy
  #   end
  # end

  describe ".delete_local_artifact" do
    it "it deletes local container images" do
      # TODO: choose an artifact that is not being used normally and will not expire
      #     NOTE: images downloaded are globally accesible to the system (another docker process could interfere)
      #container_artifact_url = "https://registry.cncf.ci/coredns/coredns:master.f636930c.48550"
      # container_image_url = "https://registry.cncf.ci/coredns/coredns"
      # image_tag = "master.f636930c.48550"
      container_image_url = "registry.hub.docker.com/library/busybox"
      image_tag = "1.28-musl"
      container_artifact_url = "#{container_image_url}:#{image_tag}"

      #pipeline = CrossCloudCi::CiService::BuildPipeline.new(options)
      #results = CrossCloudCi::CiService::ContainerRegistry.verify_container_artifact(container_artifact_url)
      CrossCloudCi::CiService::ContainerRegistry.download_container(container_artifact_url)
      expect(CrossCloudCi::CiService::ContainerRegistry.delete_local_artifact(container_artifact_url)).to be_truthy

      # TODO: use download container method
    end
  end
end

