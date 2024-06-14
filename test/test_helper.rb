require 'test/unit'
require 'shoulda'
require 'webmock'
require 'pry'
require 'vcr'

require_relative '../lib/pagarme'
require_relative 'assertions'
require_relative 'fixtures'

VCR.configure do |config|
  config.cassette_library_dir                         = 'test/vcr_cassettes'
  config.default_cassette_options[:match_requests_on] = [:method, :uri, :host, :path, :query, :body, :headers]
  config.default_cassette_options[:record]            = :new_episodes
  config.hook_into :webmock
end

class PagarMeTestCase < Test::Unit::TestCase
  FIXED_API_KEY = 'ak_test_Q2D2qDYGJSyeR1KbI4sLzGACEr73MF'
  FIXED_ENCRYPTION_KEY = 'ek_test_ZsiQ61rmOmB8mh055slzu1nxfVbAFa'

  include Fixtures::Helpers
  include Assertions

  def setup
    PagarMe.encryption_key = temporary_company.encryption_key.test
    PagarMe.api_key = temporary_company.api_key.test
  end

  def teardown
    PagarMe.encryption_key = nil
    PagarMe.api_key = nil
  end

  protected
  def ensure_positive_balance
    VCR.use_cassette 'TestCase/ensure_positive_balance' do
      transaction = PagarMe::Transaction.charge transaction_with_customer_with_boleto_params(amount: 100_000_00)
      transaction.status = :paid
      transaction.save
    end
  end

  def ensure_waiting_funds
    VCR.use_cassette 'TestCase/ensure_waiting_funds' do
      PagarMe::Transaction.create transaction_with_customer_with_card_params(amount: 10_000_00, installments: 12)
    end
  end

  def ensure_anticipable_default_recipient
    VCR.use_cassette 'TestCase/ensure_anticipable_default_recipient' do
      recipient = PagarMe::Recipient.default
      recipient.anticipatable_volume_percentage = 100
      recipient.save
    end
  end

  def change_company(api_version: nil, &block)
    company = temporary_company api_version: api_version
    change_api_and_encryption_keys api_key: company.api_key.test, encryption_key: company.encryption_key.test, &block
  end

  def change_api_and_encryption_keys(api_key: FIXED_API_KEY, encryption_key: FIXED_ENCRYPTION_KEY)
    previous_encryption_key = PagarMe.encryption_key
    previous_api_key        = PagarMe.api_key

    PagarMe.encryption_key = encryption_key
    PagarMe.api_key        = api_key
    yield

    PagarMe.encryption_key = previous_encryption_key
    PagarMe.api_key        = previous_api_key
  end
  alias :fixed_api_key :change_api_and_encryption_keys

  def temporary_company(api_version: nil)
    VCR.use_cassette "TestCase/tmp_company/api_key/#{api_version}" do
      PagarMe.api_key = FIXED_API_KEY
      PagarMe::Company.temporary api_version: api_version
    end
  end

  # Monkey Patch that adds VCR everywhere
  def self.should(description, &block)
    cassette_name = "#{ self.name.split('::').last }/should_#{ description.gsub(/\s+/, '_') }"
    super(description){ VCR.use_cassette(cassette_name){ self.instance_exec(&block) } }
  end
end
