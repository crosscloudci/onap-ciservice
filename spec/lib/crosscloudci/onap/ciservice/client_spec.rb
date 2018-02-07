# encoding: UTF-8

require 'crosscloudci/onap/ciservice/client'
require 'webmock'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
end

describe CrossCloudCi::Onap::CiService::Client do
  describe 'new client' do
    # it 'raises an error if not passed a valid configuration' do
    #   expect { CrossCloudCi::Onap::CiService::Client.new }.to raise_error
    # end
  end
end
