require_relative '../../test_helper'

module PagarMe
  class RefundTest < PagarMeTestCase

    should 'be found' do
      transaction = PagarMe::Transaction.charge transaction_with_customer_with_card_params
      transaction.refund

      assert_transaction_refunded transaction

      refunds = PagarMe::Refund.all

      assert refunds.count > 0
      refunds.each do |refund|
        assert_equal refund.status, 'refunded'
        assert_equal refund.transaction_id, transaction.id
      end
    end

  end
end
