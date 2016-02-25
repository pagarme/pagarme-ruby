require_relative '../test_helper'

module PagarMe
  class ErrorTest < Test::Unit::TestCase
    should 'be able to handle single error messages' do
      assert_transaction_errors card_number: nil
    end

    should 'be able to handle multiple error messages' do
      assert_transaction_errors amount: 10, card_expiration_year: 12
    end
  end
end