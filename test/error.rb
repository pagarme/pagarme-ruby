# encoding: utf-8
require_relative '../test_helper'

module PagarMe
  class ErrorTest < Test::Unit::TestCase

    def test_transaction_errors(options={})
      transaction = test_transaction(options)

      begin
        transaction.create
      rescue PagarMe::PagarMeError => e
        assert_no_match(/(\s?\,\s?)$/i, e.message)
      end
    end

    should 'be able to handle single error messages' do
      test_transaction_errors(card_number: nil)
    end

    should 'be able to handle multiple error messages' do
      test_transaction_errors(amount: 10, card_expiration_year: 12)
    end
  end
end