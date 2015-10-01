require 'omniauth/strategies/oauth2'
require 'openssl'
require 'rack/utils'
require 'uri'

module OmniAuth
  module Strategies
    class Airbnb < OmniAuth::Strategies::OAuth2
      DEFAULT_SCOPE = 'listings_read'

      option :client_options, {
        :authorize_url => 'https://www.airbnb.com/oauth2/auth',
        :site => 'https://api.airbnb.com/v2',
        :token_url => 'oauth2/authorizations'
      }

      option :authorize_options, [:scope]
      option :token_params, :_unwrapped => 'true'

      # You can pass +scope+ params to the auth request, if you need.
      # You can to set them dynamically also set these options in the.
      # You can OmniAuth config :authorize_params option.
      #
      # For example: /oauth2/auth?scope='reservations_read'
      def authorize_params
        super.tap do |params|
          %w(scope).each do |v|
            if request.params[v]
              params[v.to_sym] = request.params[v]
            end
          end

          params[:scope] ||= DEFAULT_SCOPE
        end
      end
    end
  end
end
