require 'spec_helper'

# TODO: Add tests for all arguments and options to build_pipeline

# Gitlab command to test:
describe "bin/build_pipeline", :type => :aruba, :exit_timeout => 600 do
  # build_pipeline artifact verify_container $CONTAINER_URL
  #
  let(:cmd) { 'bin/build_pipeline' }
  # xit "build_pipeline client exists and is executable" do
  #   #run(cmd)
  #   #expect(last_command_started).to be_successfully_executed 
  #
	# 	bin_path = File.expand_path('bin', __FILE__)
  #
	#   cmd_full_path = File.join(bin_path, cmd)
  #   expect(File.executable?(cmd_full_path)).to be_truthy
  #   #expect(cmd_full_path).to be_an_existing_executable
  # end

  it "prints a help message and exits with a 0 status if no arguments are given" do
    # run("pwd")
    run(cmd)
    # expect(last_command_started).to be_successfully_executed 
    expect(last_command_started).to have_output /download_container/
  end

  # xit "verifies the docker container given is accessible and valid" do
  #   expect(file).to be_an_existing_file
  #   expect([file]).to include an_existing_file
  # end

  describe "download_container()" do
    let(:integration_arg) { "--integration=onap" }
    let(:project_name) { "so" }
    # let(:release_type) { "stable" }
    # let(:release_arg) { "--release-type=#{release_type}" }
    let(:spec_dir) { File.expand_path('../..', __FILE__) }
    #let(:config_location) { "https://raw.githubusercontent.com/crosscloudci/cncf-configuration/integration/cross-cloud.yml" }
    let(:config_location) { File.join(spec_dir, "test-cross-cloud.yml") }

    it "retrieves a stable release container configured for that project in config specified in CROSS_CLOUD_YML environment" do
      ClimateControl.modify CROSS_CLOUD_YML: config_location do
        release_type="stable"
        release_arg = "--release-type=#{release_type}"
        cmd_with_args = "#{cmd} download_container #{integration_arg} #{release_arg} #{project_name}"
        puts "Environment var CROSS_CLOUD_YML: #{ENV['CROSS_CLOUD_YML']}"
        puts "Running command: #{cmd_with_args}"

        run(cmd_with_args)
        #expect(last_command_started).to have_output(/DEBUG OUTPUT HERE/)
        expect(last_command_started).to be_successfully_executed
      end
    end

    it "retrieves a stable release container configured for that project in config specified as commandline argument" do
      release_type="stable"
      release_arg = "--release-type=#{release_type}"
      config_location_arg = "--cross-cloud-config=#{config_location}"
      cmd_with_args = "#{cmd} download_container #{integration_arg} #{release_arg} #{config_location_arg} #{project_name}"
      puts "Running command: #{cmd_with_args}"

      run(cmd_with_args)
      #expect(last_command_started).to have_output(/DEBUG OUTPUT HERE/)
      expect(last_command_started).to be_successfully_executed
    end

    it "exits with an error if the project configuration is not found" do
      release_type="stable"
      release_arg = "--release-type=#{release_type}"

      cmd_with_args = "#{cmd} download_container #{integration_arg} #{release_arg} #{project_name}"
      puts "Running command: #{cmd_with_args}"

      run(cmd_with_args)
      expect(last_command_started).to have_output(/ERROR -- : Failed to find configuration for project/)
      #expect(last_command_started.exit_status).to eq(1)
    end
  # end

  # xdescribe "download_container() for head release" do
  #   let(:integration_arg) { "--integration=onap" }
  #   let(:project_name) { "so" }
  #   # let(:release_type) { "head" }
  #   # let(:release_arg) { "--release-type=#{release_type}" }
  #   let(:spec_dir) { File.expand_path('../..', __FILE__) }
  #   #let(:config_location) { "https://raw.githubusercontent.com/crosscloudci/cncf-configuration/integration/cross-cloud.yml" }
  #   let(:config_location) { File.join(spec_dir, "test-cross-cloud.yml") }

    it "retrieves a head release container configured for that project in config specified in CROSS_CLOUD_YML environment" do

      release_type="head"
      release_arg = "--release-type=#{release_type}"
      ClimateControl.modify CROSS_CLOUD_YML: config_location do
        cmd_with_args = "#{cmd} download_container #{integration_arg} #{release_arg} #{project_name}"
        puts "Environment var CROSS_CLOUD_YML: #{ENV['CROSS_CLOUD_YML']}"
        puts "Running command: #{cmd_with_args}"

        run(cmd_with_args)
        #expect(last_command_started).to have_output(/DEBUG OUTPUT HERE/)
        expect(last_command_started).to be_successfully_executed
      end
    end

    it "retrieves a head release container configured for that project in config specified as commandline argument" do
      release_type="head"
      release_arg = "--release-type=#{release_type}"
      config_location_arg = "--cross-cloud-config=#{config_location}"
      cmd_with_args = "#{cmd} download_container #{integration_arg} #{release_arg} #{config_location_arg} #{project_name}"
      puts "Running command: #{cmd_with_args}"

      run(cmd_with_args)
      #expect(last_command_started).to have_output(/DEBUG OUTPUT HERE/)
      expect(last_command_started).to be_successfully_executed
    end
  end

  describe "create_pinning" do
    let(:integration_arg) { "--integration=onap" }
    let(:project_name) { "so" }
    # let(:release_type) { "stable" }
    # let(:release_arg) { "--release-type=#{release_type}" }
    let(:spec_dir) { File.expand_path('../..', __FILE__) }
    #let(:config_location) { "https://raw.githubusercontent.com/crosscloudci/cncf-configuration/integration/cross-cloud.yml" }
    let(:config_location) { File.join(spec_dir, "test-cross-cloud.yml") }
    let(:config_location_arg) { "--cross-cloud-config=#{config_location}" }

    it "creates a pinning configuration for stable releases of the project" do
      release_type="stable"
      release_arg = "--release-type=#{release_type}"
      cmd_with_args = "#{cmd} create_pinnings #{integration_arg} #{release_arg} #{config_location_arg} #{project_name}"
      puts "Running command: #{cmd_with_args}"

      run(cmd_with_args)
      #expect(last_command_started).to have_output(/DEBUG OUTPUT HERE/)
      expect(last_command_started).to be_successfully_executed
    end

    it "creates a pinning configuration for head releases of the project" do
      release_type="head"
      release_arg = "--release-type=#{release_type}"
      cmd_with_args = "#{cmd} create_pinnings #{integration_arg} #{release_arg} #{config_location_arg} #{project_name}"
      puts "Running command: #{cmd_with_args}"

      run(cmd_with_args)
      #expect(last_command_started).to have_output(/DEBUG OUTPUT HERE/)
      expect(last_command_started).to be_successfully_executed
    end

  end


  describe "build_status" do
    let(:integration_arg) { "--integration=onap" }
    let(:project_name) { "so" }
    #let(:release_type) { "head" }
    #let(:release_arg) { "--release-type=#{release_type}" }
    let(:spec_dir) { File.expand_path('../..', __FILE__) }
    #let(:config_location) { "https://raw.githubusercontent.com/crosscloudci/cncf-configuration/integration/cross-cloud.yml" }
    let(:config_location) { File.join(spec_dir, "test-cross-cloud.yml") }
    let(:config_location_arg) { "--cross-cloud-config=#{config_location}" }

    #it "returns friendly message that stable build status is not supported from onap jenkins and displays it" do
    it "ignores request/noop for stable build status which is not supported for onap stable releases" do
      release_type="stable"
      release_arg = "--release-type=#{release_type}"
      cmd_with_args = "#{cmd} build_status #{integration_arg} #{release_arg} #{config_location_arg} #{project_name}"
      puts "Running command: #{cmd_with_args}"

      run(cmd_with_args)
      expect(last_command_started).to have_output("Build status: n/a")
      expect(last_command_started).to be_successfully_executed
    end

    it "retrieves the head (nightly) build status from onap jenkins and displays it" do
      release_type="head"
      release_arg = "--release-type=#{release_type}"
      cmd_with_args = "#{cmd} build_status #{integration_arg} #{release_arg} #{config_location_arg} #{project_name}"
      puts "Running command: #{cmd_with_args}"

      run(cmd_with_args)
      #expect(last_command_started).to have_output(/DEBUG OUTPUT HERE/)
      expect(last_command_started).to be_successfully_executed
    end
  end
end


 
