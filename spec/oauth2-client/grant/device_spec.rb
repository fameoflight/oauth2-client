require File.expand_path('../../spec_helper', __dir__)

describe OAuth2Client::Grant::DeviceCode do
  before :all do
    @host           = 'example.com'
    @client_id      = 's6BhdRkqt3'
    @client_secret  = 'SplxlOBeZQQYbYS6WxSbIA'
    @client = OAuth2Client::Client.new(@host, @client_id, @client_secret)
  end

  subject do
    OAuth2Client::Grant::DeviceCode.new(@client)
  end

  describe '#grant_type' do
    it 'returns grant type' do
      expect(subject.grant_type).to eq 'http://oauth.net/grant_type/device/1.0'
    end
  end

  describe '#get_code' do
    it 'gets user code' do
      subject.should_receive(:make_request).with(:post, '/oauth2/device/code', {
                                                   params: { client_id: 's6BhdRkqt3' }
                                                 })
      subject.get_code
    end
  end

  describe '#get_token' do
    it 'gets access token' do
      subject.should_receive(:make_request).with(:post, '/oauth2/token', {
                                                   params: { code: 'G3Y6jU3a',
                                                             grant_type: 'http://oauth.net/grant_type/device/1.0' },
                                                   authenticate: :headers
                                                 })
      subject.get_token('G3Y6jU3a')
    end
  end
end
