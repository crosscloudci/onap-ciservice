require 'spec_helper'

RSpec.describe 'Integrate Aruba into RSpec', :type => :aruba do
  context 'when to be or not be...' do
    it { expect(aruba).to be }
  end

  context 'when write file' do
    let(:file) { 'file.txt' }

    before(:each) { write_file file, 'Hello World' }

    it { expect(file).to be_an_existing_file }
    it { expect([file]).to include an_existing_file }
  end
end

# Gitlab command to test:
describe "bin/build_pipeline", :type => :aruba do
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

  # INTEGRATION_NAME="onap-mso"
  # build_pipeline --integration $INTEGRATION_NAME artifact verify_container $CONTAINER_URL 
  describe "ONAP Integration" do
    xit "verifies the ONAP docker container given is accessible and valid" do
    end
  end
end
 
