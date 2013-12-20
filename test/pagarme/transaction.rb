# encoding: utf-8
require_relative '../test_helper'

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

	should 'be able to create transaciton with boleto' do
	  transaction = PagarMe::Transaction.new({
		:payment_method => "boleto",
		:amount => "1000"
	  })
	  transaction.charge

	  assert transaction.payment_method == 'boleto'
	  assert transaction.status == 'waiting_payment'
	  assert transaction.amount.to_s == '1000'
	end

	should 'be able to send metadata' do
	  transaction = test_transaction
	  transaction.metadata = {event: {:name => "Evento foda", :id => 335}}
	  transaction.charge
	  assert transaction.metadata

	  transaction2 = PagarMe::Transaction.find_by_id(transaction.id)
	  assert transaction2.metadata.event.id.to_i == 335
	  assert transaction2.metadata.event.name == "Evento foda"
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

	should 'should allow transactions with R$ amount' do
	  transaction = test_transaction
	  transaction.amount = 'R$ 10.00'
	  transaction.charge
	  assert transaction.amount == 1000
	end

	should 'validate invalid transaction' do

	  #Test invalid card_number
		  exception = assert_raises PagarMeError do
		  transaction = PagarMe::Transaction.new({
			:amount => "1000",
			:card_number => '123456',
			:card_holder_name => "Jose da Silva",
		  })
		  transaction.charge
		  end
		assert exception.errors.first.parameter_name == 'card_number'

		#Test missing card_holder_name
		exception = assert_raises PagarMeError do
		  transaction = PagarMe::Transaction.new({
			:card_number => '4111111111111111',
			:amount => "1000",
		  })
		  transaction.charge
		end
		assert exception.errors.first.parameter_name == 'card_holder_name'

		#Test invalid expiracy month
		exception = assert_raises PagarMeError do
		  transaction = PagarMe::Transaction.new({
			:card_number => '4111111111111111',
			:card_holder_name => "Jose da Silva",
			:amount => "1000",
			:card_expiracy_month => 15
		  })
		  transaction.charge
		end
		assert exception.errors.first.parameter_name == 'card_expiration_date'

		#Test invalid expiracy year
		exception = assert_raises PagarMeError do
		  transaction = PagarMe::Transaction.new({
			:card_number => '4111111111111111',
			:card_holder_name => "Jose da Silva",
			:amount => "1000",
			:card_expiration_month => 12,
			:card_expiration_year => -1,
		  })
		  transaction.charge
		end
		assert exception.errors.first.parameter_name == 'card_expiration_date'

		#Test invalid expiracy year
		exception = assert_raises PagarMeError do
		  transaction = PagarMe::Transaction.new({
			:card_number => '4111111111111111',
			:card_holder_name => "Jose da Silva",
			:amount => "1000",
			:card_expiration_month => 12,
			:card_expiration_year => 16,
		  })
		  transaction.charge
		end
		assert exception.errors.first.parameter_name == 'card_cvv'
	  end
	end
  end
