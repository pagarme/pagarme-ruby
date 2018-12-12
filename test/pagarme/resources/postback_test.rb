require_relative '../../test_helper'
require 'json'

module PagarMe
  class PostbackTest < PagarMeTestCase
    should 'be valid when has valid signature' do
      fixed_api_key do
        postback = PagarMe::Postback.new postback_response_params
        assert postback.valid?
      end
    end

    should 'not be valid when has invalid signature' do
      postback = PagarMe::Postback.new postback_response_params(signature: 'sha1=invalid signature')
      assert !postback.valid?
    end

    should 'validate signature' do
      fixed_api_key do
        params = postback_response_params
        assert  PagarMe::Postback.valid_request_signature?(params[:payload], params[:signature])
        assert !PagarMe::Postback.valid_request_signature?(params[:payload], params[:signature][4..-1])
        assert !PagarMe::Postback.valid_request_signature?(params[:payload], 'invalid signature')
      end
    end

    should 'redeliver a transaction postback' do
      transaction = PagarMe::Transaction.create transaction_with_customer_with_card_with_postback_params

      postback = PagarMe::Postback.new
      loop do
        postback = transaction.postbacks.last
        break unless postback.nil?
      end

      redeliver = postback.redeliver
     
      assert_equal redeliver["status"], 'pending_retry'
    end

    should 'redeliver a subscription postback' do
      subscription = PagarMe::Subscription.create subscription_with_customer_with_boleto_with_no_trial_plan_with_postback_params

      subscription_transaction = PagarMe::Transaction.new
      loop do
        subscription_transaction = subscription.transactions.last
        break unless subscription_transaction.nil?
      end

      subscription_transaction.status = 'paid'
      subscription_transaction.save

      postback = PagarMe::Postback.new
      loop do 
        postback = subscription.postbacks.last
        break if postback != nil?
      end

      redeliver = postback.redeliver

      assert_equal redeliver["status"], 'pending_retry'
    end
  end
end
