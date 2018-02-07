# encoding: UTF-8

require 'crosscloudci/onap/ciservice'

describe CrossCloudCi::Onap::CiService do
  describe '.client' do
    it 'returne a client object' do
      client = CrossCloudCi::Onap::CiService.client

      expect(client).to be_a(CrossCloudCi::Onap::CiService::Client)
    end
  end
end
