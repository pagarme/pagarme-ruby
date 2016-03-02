require_relative '../../test_helper'

module PagarMe
  class TransactionTest < Test::Unit::TestCase
    should 'be valid when has valid fingerprint' do
      fixed_api_key do
        postback = PagarMe::Postback.new postback_response_params
        assert postback.valid?
      end
    end

    should 'be valid when has invalid fingerprint' do
      invalid_fingerprint = Digest::SHA1.hexdigest 'Invalid Fingerprint!'
      postback = PagarMe::Postback.new postback_response_params(fingerprint: invalid_fingerprint)
      assert !postback.valid?
    end
  end
end
