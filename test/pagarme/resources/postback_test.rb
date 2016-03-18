require_relative '../../test_helper'

module PagarMe
  class TransactionTest < Test::Unit::TestCase
    should 'be valid when has valid signature' do
      fixed_api_key do
        postback = PagarMe::Postback.new postback_response_params
        assert postback.valid?
      end
    end

    should 'be valid when has invalid signature' do
      postback = PagarMe::Postback.new postback_response_params(signature: 'invalid signature')
      assert !postback.valid?
    end

    should 'validate signature' do
      params = postback_response_params
      assert  PagarMe::Postback.valid_request_signature?(params[:payload], "sha1=#{params[:signature]}")
      assert !PagarMe::Postback.valid_request_signature?(params[:payload], params[:signature])
      assert !PagarMe::Postback.valid_request_signature?(params[:payload], 'invalid signature')
    end
  end
end
