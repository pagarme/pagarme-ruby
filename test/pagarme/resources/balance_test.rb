require_relative '../../test_helper'

module PagarMe
  class BalanceTest < Test::Unit::TestCase

    should 'change amount amount after transaction being paid' do
      transaction      = PagarMe::Transaction.charge transaction_with_boleto_params
      previous_balance = PagarMe::Balance.balance

      transaction.status = :paid
      transaction.save

      balance = PagarMe::Balance.balance
      assert_increased_available_amount previous_balance, balance
    end

    should 'change recipient amount after transaction being paid' do
      recipient   = PagarMe::Recipient.create recipient_with_nested_bank_account_params
      split_rules = [ { recipient_id: recipient.id, percentage: 100 } ]
      transaction = PagarMe::Transaction.charge transaction_with_boleto_params(split_rules: split_rules)

      assert_empty_balance recipient.balance

      transaction.status = :paid
      transaction.save

      assert_available_balance recipient.balance
    end

    should 'change recipient amount after recipient receive money' do
      recipient   = PagarMe::Recipient.create recipient_with_nested_bank_account_params
      split_rules = [ { recipient_id: recipient.id, percentage: 100 } ]
      transaction = PagarMe::Transaction.charge transaction_with_boleto_params(split_rules: split_rules)

      assert_empty_balance recipient.balance

      transaction.status = :paid
      transaction.save

      recipient.receive recipient.balance.available.amount

      assert_transfered_balance recipient.balance
    end

  end
end
