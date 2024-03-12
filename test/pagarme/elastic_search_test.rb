require_relative '../test_helper'

module PagarMe
  class ElasticSearchTest < PagarMeTestCase
    should 'find a transaction' do
      transaction = PagarMe::Transaction.charge transaction_with_customer_with_card_params
      assert_transaction_successfully_paid transaction

      other_transaction = PagarMe::Transaction.search({match: {id: transaction.id}}).hits.hits[0]
      assert_equal transaction.id, other_transaction._id.to_i
    end

    # should 'find a payable' do
    #   transaction = PagarMe::Transaction.charge transaction_with_customer_with_card_params
    #   assert_transaction_successfully_paid transaction

    #   puts pbs = transaction.payables
    #   puts "====== BUSCA POR Payable!! === No Transaction Id #{transaction.id}"
    #   payables = PagarMe::Payable.search({match: {_transaction_id: transaction.id}})
    #   puts payables.to_yaml
    #   assert_equal pbs.first.id, payables.hits.hits[0]._id
    # end

    should 'find a list of paid transactions' do
      payables = PagarMe::Transaction.search({match: {status: 'paid'}}).hits.hits
      assert_equal payables.size, 10
    end

    should 'find a list of payables' do
      payables = PagarMe::Transaction.search({match_all: {}}).hits.hits
      assert_equal payables.size, 10
    end
  end
end