require File.expand_path('../../test_helper', __FILE__)

module PagarMe
  class TransactionTest < Test::Unit::TestCase

	should 'be able to charge' do
	  transaction = test_transaction
	  assert transaction.status == 'local'
	  transaction.charge
	  assert transaction.status == 'paid'
	  test_transaction_response(transaction)
	end

	should 'be able to refund' do
	  transaction = test_transaction
	  transaction.charge
	  test_transaction_response(transaction)
	  transaction.refund
	  assert transaction.status == 'refunded'
	end

	should 'be able to find a transaction' do
	  transaction = test_transaction
	  transaction.charge
	  test_transaction_response(transaction)

	  transaction_2 = PagarMe::Transaction.find_by_id(transaction.id)
	  assert transaction_2.id == transaction.id
	end

	should 'be able to create transaction with customer' do
	  transaction = test_transaction_with_customer
	  transaction.charge
	  test_transaction_response(transaction)
	  assert transaction.customer.class == Customer
	  test_customer_response(transaction.customer)
	end

	should 'be able to refund transaction with customer' do
	  transaction = test_transaction_with_customer
	  transaction.charge
	  test_transaction_response(transaction)
	  assert transaction.customer.class == Customer
	  test_customer_response(transaction.customer)
	  transaction.refund

	  assert transaction.status == 'refunded'
	end


  end
end
