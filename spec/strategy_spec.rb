require 'spec_helper'

describe OmniAuth::Strategies::Airbnb do
  let(:client_id)     { '123' }
  let(:client_secret) { '53cr3tz' }
  let(:options)       { Hash.new }
  let(:request)       { double('Request') }

  let(:strategy) do
    args = [client_id, client_secret, options].compact
    OmniAuth::Strategies::Airbnb.new(nil, *args).tap do |strategy|
      allow(strategy).to receive(:request) { request }
    end
  end


  it 'has correct Facebook site' do
    expect(strategy.client.site).to eq 'https://api.airbnb.com/v2'
  end

  it 'has correct authorize url' do
    authorize_url = strategy.client.options[:authorize_url]
    expect(authorize_url).to eq 'https://www.airbnb.com/oauth2/auth'
  end

  # it 'has correct token url with versioning' do
  #   @options = {:client_options => {:site => 'https://graph.facebook.net/v2.2'}}
  #   assert_equal 'oauth/access_token', strategy.client.options[:token_url]
  #   assert_equal 'https://graph.facebook.net/v2.2/oauth/access_token', strategy.client.token_url
  # end
end
