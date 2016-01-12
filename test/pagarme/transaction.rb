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

	should 'be able to charge with a saved card' do
	  card = test_card
	  card.create

	  transaction = PagarMe::Transaction.new({
		:card => card,
		:amount => 1000,
		:payment_method => 'credit_card'
	  })

	  transaction.charge
	  assert transaction.status == 'paid'
	end

	should 'be able to charge with an unsaved card' do
	  card = test_card
	  transaction = PagarMe::Transaction.new({
		:card => card,
		:amount => 1000,
		:payment_method => 'credit_card'
	  })

	  transaction.charge
	  assert transaction.status == 'paid'
	end

	should 'return a card object' do
	  transaction = test_transaction
	  transaction.create
	  assert transaction.card.id
	  assert transaction.card.first_digits == '490172'
	  assert transaction.card.last_digits == '4448'
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

	should 'accept parameters on the refund' do
	  transaction = PagarMe::Transaction.new({
	  	:payment_method => 'boleto',
		:amount => '1000'
	  })

	  transaction2 = PagarMe::Transaction.new({
	  	:payment_method => 'boleto',
		:amount => '1000'
	  })
	  
	  transaction.charge
	  transaction2.charge

	  transaction.status = 'paid'
	  transaction.save

	  transaction2.status = 'paid'
	  transaction2.save

	  transaction.refund({bank_account: {:bank_code => '399', :agencia => '1234', :conta => '1234567', :conta_dv => '1', :legal_name => 'Jose da silva', :document_number => '68782915423'}})
	  assert transaction.status == 'pending_refund'
	end

    should 'be able to create transaction with customer' do
      transaction = test_transaction_with_customer
      transaction.charge
      test_transaction_response(transaction)
      assert transaction.address.class == Address
      assert transaction.address.street== 'Av. Brigadeiro Faria Lima'
      assert transaction.customer.class == Customer
      test_customer_response(transaction.customer)
	  assert transaction.customer.email = "henrique+test@pagar.me"
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

	should 'be able to capture a transaction and pass an amount' do
	  transaction = test_transaction({:capture => false})
	  transaction.charge
	  assert transaction.status == 'authorized'
	  transaction.capture({:amount => 1000})
	  assert transaction.status == 'paid'
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

	  should 'calculate installments' do
      installments_result = PagarMe::Transaction.calculate_installments({
        amount: 10000,
        interest_rate: 0
      })

      assert installments_result['installments'].size == 12
      assert installments_result['installments']['2']['installment_amount'] == 5000
    end

    should 'be able to notify by email about a bank_slip to be paid' do
      transaction = PagarMe::Transaction.new({
        :payment_method => 'boleto',
        :amount => '1000'
      })
      transaction.charge
      assert_raise PagarMe::PagarMeError do
        transaction.collect_payment(:email => 'customer@mailinator.com')
      end
    end
  end
end
