require 'spec_helper'

RSpec.describe OmniAuth::Strategies::Donorhub do
  let(:app) { lambda { [200, {}, ["Hello."]] } }
  let(:subject) { OmniAuth::Strategies::Donorhub.new(app, 'test_client_id', 'test_client_secret', @options) }

  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.test_mode = false
  end

  describe '#client' do
    it 'should be initialized with symbolized client_options' do
      @options = { :client_options => { 'authorize_url' => 'https://example.com' } }
      expect(subject.client.options[:authorize_url]).to eq('https://example.com')
    end

    context 'oauth_url set at initialization' do
      let(:subject) do
        OmniAuth::Strategies::Donorhub.new(
          app,
          'test_client_id',
          'test_client_secret',
          'https://www.mytntware.com/dataserver/toontown/staffportal/oauth/authorize.aspx'
        )
      end

      it 'should set authorize_url based on oauth_url' do
        expect(subject.client.options[:authorize_url]).to eq('/dataserver/toontown/staffportal/oauth/authorize.aspx')
      end

      it 'should set token_url based on oauth_url' do
        expect(subject.client.options[:token_url]).to eq('/dataserver/toontown/staffportal/oauth/authorize.aspx')
      end

      it 'should set site based on oauth_url' do
        expect(subject.client.site).to eq('https://www.mytntware.com')
      end
    end

    context 'oauth_url set at runtime' do
      let(:subject) do
        OmniAuth::Strategies::Donorhub.new(
          app,
          'test_client_id',
          'test_client_secret'
        )
      end

      before do
        allow(subject).to receive(:env) { {} }
        allow(subject).to receive(:request) do
          OpenStruct.new(
            params: {
              'oauth_url' => 'https://www.mytntware.com/dataserver/toontown/staffportal/oauth/authorize.aspx'
            }
          )
        end
      end

      it 'should set authorize_url based on oauth_url' do
        expect(subject.client.options[:authorize_url]).to eq('/dataserver/toontown/staffportal/oauth/authorize.aspx')
      end

      it 'should set token_url based on oauth_url' do
        expect(subject.client.options[:token_url]).to eq('/dataserver/toontown/staffportal/oauth/authorize.aspx')
      end

      it 'should set site based on oauth_url' do
        expect(subject.client.site).to eq('https://www.mytntware.com')
      end
    end
  end

  describe '#authorize_params' do
    it 'should include any authorize params passed in the :authorize_params option' do
      @options = { :authorize_params => { :foo => 'bar', :baz => 'zip' } }
      expect(subject.authorize_params['foo']).to eq('bar')
      expect(subject.authorize_params['baz']).to eq('zip')
    end

    it 'should include top-level options that are marked as :authorize_options' do
      @options = { :authorize_options => [:scope, :foo], :scope => 'bar', :foo => 'baz' }
      expect(subject.authorize_params['scope']).to eq('bar')
      expect(subject.authorize_params['foo']).to eq('baz')
    end
  end

  describe '#token_params' do
    it 'should include any authorize params passed in the :authorize_params option' do
      @options = { :token_params => { :foo => 'bar', :baz => 'zip' } }
      expect(subject.token_params['foo']).to eq('bar')
      expect(subject.token_params['baz']).to eq('zip')
    end

    it 'should include top-level options that are marked as :authorize_options' do
      @options = { :token_options => [:scope, :foo], :scope => 'bar', :foo => 'baz' }
      expect(subject.token_params['scope']).to eq('bar')
      expect(subject.token_params['foo']).to eq('baz')
    end
  end
end
