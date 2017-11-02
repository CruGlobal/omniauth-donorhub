require 'json'
require 'omniauth-oauth'

module OmniAuth
  module Strategies
    class Donorhub < OmniAuth::Strategies::OAuth
      option :name, 'donorhub'

      option :client_options, {
        site: request.params['oauth_url']
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
