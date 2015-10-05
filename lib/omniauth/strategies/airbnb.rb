require 'omniauth/strategies/oauth2'
require 'openssl'
require 'rack/utils'
require 'uri'

module OmniAuth
  module Strategies
    class Airbnb < OmniAuth::Strategies::OAuth2
      DEFAULT_SCOPE = 'basic_profile_read'

      option :client_options, {
        :authorize_url => 'https://www.airbnb.com/oauth2/auth',
        :site => 'https://api.airbnb.com/v2',
        :token_url => 'oauth2/authorizations'
      }

      option :authorize_options, [:scope]
      option :token_params, :_unwrapped => 'true'

      uid { user_info['id'] }

      info do
        {
          'email'         => user_info['email'],
          'first_name'    => user_info['first_name'],
          'last_name'     => user_info['last_name'],
          'image'         => user_info['picture_url'],
          'description'   => user_info['about'],
          'location'      => user_info['location'],
          'verifications' => user_info['verifications'],
          'phone'         => user_info['phone']
        }
      end

      extra do
        skip_info?? Hash.new : {'raw_info' => raw_info}
      end

      def authorize_params
        super.tap do |params|
          params[:scope] = request.params['scope'] || DEFAULT_SCOPE
        end
      end

      def raw_info
        @raw_info ||= access_token.get('users/me').parsed || {}
      end

      def user_info
        @user_info ||= raw_info['user'] || {}
      end
    end
  end
end
