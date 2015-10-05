require 'spec_helper'

RSpec.describe OmniAuth::Strategies::Airbnb do
  subject(:strategy) do
    OmniAuth::Strategies::Airbnb.new(nil, {})
  end

  it 'adds a camelization for itself' do
    expect(OmniAuth::Utils.camelize('airbnb')).to eq 'Airbnb'
  end

  context 'client options' do
    it 'has correct Airbnb site' do
      expect(strategy.options.client_options.site).
        to eq 'https://api.airbnb.com/v2'
    end

    it 'has correct authorize url' do
      expect(strategy.options.client_options.authorize_url).
        to eq 'https://www.airbnb.com/oauth2/auth'
    end
  end

  describe 'token url' do
    it 'has correct token path' do
      expect(strategy.client.options[:token_url]).
        to eq 'oauth2/authorizations'
    end

    it 'has correct token url with versioning' do
      expect(strategy.client.token_url).
        to eq 'https://api.airbnb.com/v2/oauth2/authorizations'
    end
  end

  context '#uid' do
    before do
      allow(strategy).to receive(:user_info).and_return('id' => '123')
    end

    it 'returns the id from raw_info' do
      expect(strategy.uid).to eq '123'
    end
  end

  context 'returns info hash conformant with omniauth auth hash schema' do
    before do
      allow(strategy).to receive(:raw_info).and_return({})
    end

    context 'and therefore has all the necessary fields' do
      it {expect(strategy.info).to have_key 'email'}
      it {expect(strategy.info).to have_key 'first_name'}
      it {expect(strategy.info).to have_key 'last_name'}
      it {expect(strategy.info).to have_key 'image'}
      it {expect(strategy.info).to have_key 'description'}
      it {expect(strategy.info).to have_key 'location'}
      it {expect(strategy.info).to have_key 'verifications'}
      it {expect(strategy.info).to have_key 'phone'}
    end
  end
end
