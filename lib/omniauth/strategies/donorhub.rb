require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Donorhub < OmniAuth::Strategies::OAuth2
      option :name, 'donorhub'

      args [:client_id, :client_secret, :oauth_url]

      option :client_options, {
        site: '',
        token_method: :get
      }

      option :authorize_params, {
        client_instance: 'n/a'
      }

      uid { request.params['id'] }

      info do
        {}
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        @raw_info ||= {}
      end

      def query_string
        request.delete_param('code')
        request.delete_param('state')
        request.params.to_query ? "?#{request.params.to_query}" : ''
      end

      def client
        return super unless oauth_url
        options.client_options.site = oauth_site
        options.client_options.authorize_url = oauth_path
        options.client_options.token_url = oauth_path
        super
      end

      private

      def oauth_path
        @oauth_path ||= URI(oauth_url).request_uri
      end

      def oauth_site
        return @oauth_site if @oauth_site
        uri = URI(oauth_url)
        uri.path = ''
        uri.query = nil
        @oauth_site = uri.to_s
      end

      def oauth_url
        return @oauth_url if @oauth_url
        if env.nil?
          @oauth_url = options.oauth_url
        else
          @oauth_url = request.params['oauth_url'] || options.oauth_url
        end
      end
    end
  end
end
