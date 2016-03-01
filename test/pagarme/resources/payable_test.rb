require_relative '../../test_helper'

module PagarMe
  class PayableTest < Test::Unit::TestCase
    should 'be created setting default recipient on payable' do
      transaction = PagarMe::Transaction.create transaction_with_customer_with_card_params
      payable     = transaction.payables.first

      assert_equal transaction.payables.count, 1
      assert_equal payable.recipient_id, PagarMe::Recipient.default.id
    end

    should 'create one per split rule' do
      transaction = PagarMe::Transaction.create transaction_with_customer_with_card_with_split_rules_params
      payable     = transaction.payables.first

      assert_equal transaction.payables.count, 4
      assert_equal transaction.payables.map(&:recipient_id).sort, fixtures.persistent_recipient_ids.sort
    end

    should 'create be found' do
      payables = PagarMe::Payable.find_by type: 'refund'

      assert payables.count > 0
      payables.each do |payable|
        assert_equal payable.type, 'refund'
      end
    end
  end
end
