# encoding: UTF-8

require 'crosscloudci/ciservice/onap'

describe CrossCloudCi::CiService::Onap do
  describe '.client' do
    it 'returne a client object' do
      client = CrossCloudCi::CiService::Onap.client

      expect(client).to be_a(CrossCloudCi::CiService::Onap::Client)
    end
  end
end
