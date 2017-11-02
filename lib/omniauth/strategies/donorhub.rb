require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Donorhub < OmniAuth::Strategies::OAuth2
      option :name, 'donorhub'

      option :client_options, {
        site: ''
      }

      option :authorize_params, {
        client_instance: 'n/a'
      }

      uid { request.params['id'] }

      info do
        {
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        @raw_info ||= {}
      end
    end
  end
end
