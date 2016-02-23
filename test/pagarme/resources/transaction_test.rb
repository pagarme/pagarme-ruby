require_relative '../../test_helper'

module PagarMe
  class TransactionTest < Test::Unit::TestCase
    def setup
      super
      ensure_positive_balance
    end

    should 'be able to charge' do
      transaction = PagarMe::Transaction.new transaction_with_customer_with_card_params
      assert_equal transaction.status, 'local'

      transaction.charge
      assert_transaction_successfully_paid transaction
    end

    should 'be able to set postback url' do
      transaction = PagarMe::Transaction.create transaction_with_card_with_postback_params
      assert_transaction_successfully_processing transaction
    end

    should 'not be able to charge when refused card' do
      transaction = PagarMe::Transaction.new transaction_with_customer_with_refused_card_params
      assert_equal transaction.status, 'local'

      transaction.charge
      assert_transaction_refused_by_acquirer transaction
    end

    should 'be able to charge with a saved card' do
      card        = PagarMe::Card.create card_params
      transaction = PagarMe::Transaction.charge customer_params(card: card, amount: 1000)
      assert_transaction_successfully_paid transaction
    end

    should 'be able to charge with an unsaved card' do
      card        = PagarMe::Card.new card_params
      transaction = PagarMe::Transaction.charge customer_params(card: card, amount: 1000)
      assert_transaction_successfully_paid transaction
    end

    should 'be able to refund' do
      transaction = PagarMe::Transaction.charge transaction_with_customer_with_card_params
      assert_transaction_successfully_paid transaction

      transaction.refund
      assert_equal transaction.status, 'refunded'
    end

    should 'be able to create transaciton with boleto' do
      transaction = PagarMe::Transaction.charge transaction_with_boleto_params
      assert_transaction_with_bolelo_on_waiting_payment transaction
    end

    should 'be able to send and retrieve metadata' do
      metadata = {
        'metadata' => {
          'event' => {
            'id'   => 335,
            'name' => 'Evento foda'
          }
        }
      }
      transaction = PagarMe::Transaction.charge transaction_with_customer_with_card_params(metadata)
      assert_equal transaction.metadata.to_hash, metadata['metadata']

      found_transaction = PagarMe::Transaction.find_by_id transaction.id
      assert_equal found_transaction.metadata.to_hash, metadata['metadata']
    end

    should 'be able to find a transaction' do
      transaction = PagarMe::Transaction.charge transaction_with_customer_with_card_params
      assert_transaction_successfully_paid transaction

      other_transaction = PagarMe::Transaction.find_by_id transaction.id
      assert_equal transaction.id, other_transaction.id
      assert_equal transaction,    other_transaction
    end

    should 'raise an error when nil or empty string as ID' do
      assert_raises RequestError do
        PagarMe::Transaction.find_by_id nil
      end

      assert_raises RequestError do
        PagarMe::Transaction.find_by_id ''
      end
    end

    should 'require parameters on the refund with boleto' do
      transaction = PagarMe::Transaction.create transaction_with_boleto_params
      assert_equal transaction.status, 'waiting_payment'

      assert_raises(PagarMe::ValidationError){ transaction.refund }
      assert_raises(PagarMe::ValidationError){ transaction.refund refund_bank_account_params }
      assert_equal transaction.status, 'waiting_payment'

      transaction.status = 'paid'
      transaction.save
      assert_equal transaction.status, 'paid'

      assert_raises(PagarMe::ValidationError){ transaction.refund }
      assert_equal transaction.status, 'paid'

      transaction.refund refund_bank_account_params
      assert_equal transaction.status, 'pending_refund'

      found_transaction = PagarMe::Transaction.find_by_id transaction.id
      assert_equal found_transaction.status, 'pending_refund'
    end

    should 'be able to create transaction with customer' do
      transaction = PagarMe::Transaction.charge transaction_with_card_with_customer_params
      assert_transaction_with_customer_successfully_paid transaction
    end

    should 'be able to refund transaction with customer' do
      transaction = PagarMe::Transaction.charge transaction_with_card_with_customer_params
      assert_transaction_with_customer_successfully_paid transaction

      transaction.refund
      assert_equal transaction.status, 'refunded'
    end

    should 'be able to capture a transaction and pass an amount' do
      transaction = PagarMe::Transaction.charge transaction_with_customer_with_card_params(capture: false, amount: 2000)
      assert_equal transaction.status,          'authorized'
      assert_equal transaction.amount,          2000
      assert_equal transaction.paid_amount,     0
      assert_equal transaction.refunded_amount, 0

      transaction.capture amount: 1000
      assert_equal transaction.status,          'paid'
      assert_equal transaction.amount,          2000
      assert_equal transaction.paid_amount,     1000
      assert_equal transaction.refunded_amount, 0
    end

    should 'validate transaction with invalid card_number' do
      exception = assert_raises PagarMe::ValidationError do
        PagarMe::Transaction.charge transaction_with_card_params(card_number: '123456')
      end
      assert exception.errors.any?{ |error| error.parameter_name == 'card_number' }
    end

    should 'validate transaction missing card_holder_name' do
      exception = assert_raises PagarMe::ValidationError do
        params = {
          card_number: '4111111111111111',
          amount:      '1000'
        }
        PagarMe::Transaction.charge params
      end
      assert exception.errors.any?{ |error| error.parameter_name == 'card_holder_name' }
    end

    should 'validate transaction with invalid expiracy month' do
      exception = assert_raises PagarMe::ValidationError do
        params = {
          card_number:         '4111111111111111',
          card_holder_name:    'Jose da Silva',
          amount:              '1000',
          card_expiracy_month: 15
        }
        PagarMe::Transaction.charge params
      end
      assert exception.errors.any?{ |error| error.parameter_name == 'card_expiration_date' }
    end

    should 'validate transaction invalid expiracy year' do
      exception = assert_raises PagarMe::ValidationError do
        params = {
          card_number:           '4111111111111111',
          card_holder_name:      'Jose da Silva',
          amount:                '1000',
          card_expiration_month: 12,
          card_expiration_year:  -1,
        }
        PagarMe::Transaction.charge params
      end
      assert exception.errors.any?{ |error| error.parameter_name == 'card_expiration_date' }
    end

    should 'validate transaction missing cvv' do
      exception = assert_raises PagarMe::ValidationError do
        params = {
          card_number:           '4111111111111111',
          card_holder_name:      'Jose da Silva',
          amount:                '1000',
          card_expiration_month: 12,
          card_expiration_year:  16,
        }
        PagarMe::Transaction.charge params
      end
      assert exception.errors.any?{ |error| error.parameter_name == 'card_cvv' }
    end

    should 'be able to split transaction' do
      transaction = PagarMe::Transaction.charge transaction_with_customer_with_card_with_split_rules_params
      assert_split_rules transaction.split_rules
    end

    should 'raise error when there is an invalid split rule' do
      assert_raises PagarMe::ValidationError do
        PagarMe::Transaction.charge transaction_with_card_with_invalid_split_rules_params
      end
    end

    should 'calculate installments' do
      amount = 10000
      result = PagarMe::Transaction.calculate_installments amount: amount, interest_rate: 0

      assert_equal result['installments'].size, 12
      (1..12).each do |i|
        installment = (amount.to_f/i).round
        assert_equal result['installments'][i.to_s]['installment_amount'], installment
      end
    end
  end
end
