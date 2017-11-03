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

  it_should_behave_like 'an oauth2 strategy'
end
