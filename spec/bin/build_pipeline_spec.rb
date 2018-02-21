require 'spec_helper'

# TODO: Add tests for all arguments and options to build_pipeline

# Gitlab command to test:
describe "bin/build_pipeline", :type => :aruba, :exit_timeout => 600 do
  # build_pipeline artifact verify_container $CONTAINER_URL
  #
  let(:cmd) { 'bin/build_pipeline' }
  xit "build_pipeline client exists and is executable" do
    #run(cmd)
    #expect(last_command_started).to be_successfully_executed 

		bin_path = File.expand_path('bin', __FILE__)

	  cmd_full_path = File.join(bin_path, cmd)
    expect(File.executable?(cmd_full_path)).to be_truthy
    #expect(cmd_full_path).to be_an_existing_executable
  end

  it "prints a help message and exits with a 0 status if no arguments are given" do
    # run("pwd")
    run(cmd)
    # expect(last_command_started).to be_successfully_executed 
    expect(last_command_started).to have_output /download_container/
  end

  xit "verifies the docker container given is accessible and valid" do
    expect(file).to be_an_existing_file
    expect([file]).to include an_existing_file
  end

  describe "download_container" do
    it "retrieves a container for the project given for the registry configured for that project" do
      release_type = "stable"
      release_arg = "--release-type=#{release_type}"
      integration_arg = "--integration=onap"
      project_name = "so"
      cmd_with_args = "#{cmd} download_container #{integration_arg} #{release_arg} #{project_name}"
      puts "Running command: #{cmd_with_args}"

      run(cmd_with_args)
      expect(last_command_started).to have_output /DEBUG OUTPUT HERE/
      expect(last_command_started).to be_successfully_executed
    end
  end
end


 
