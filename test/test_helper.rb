require 'test/unit'
require 'shoulda'
require 'webmock'
require 'pry'
require 'vcr'

require_relative '../lib/pagarme'
require_relative 'assertions'
require_relative 'fixtures'

VCR.configure do |config|
  config.cassette_library_dir = 'test/vcr_cassettes'
  config.default_cassette_options[:match_requests_on] = [:method, :uri, :host, :path, :query, :body, :headers]
  config.default_cassette_options[:record]            = :new_episodes
  config.hook_into :webmock
end

class Test::Unit::TestCase
  include Fixtures::Helpers
  include Assertions

  def setup
    PagarMe.api_key = 'ak_test_Rw4JR98FmYST2ngEHtMvVf5QJW7Eoo'
  end

  def teardown
    PagarMe.api_key = nil
  end

  # Monkey Patch that adds VCR everywhere
  def self.should(description, &block)
    cassette_name = "#{ self.name.split('::').last }/should_#{ description.gsub /\s+/, '_' }"
    super(description){ VCR.use_cassette(cassette_name){ self.instance_exec &block } }
  end
end
