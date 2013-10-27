require File.expand_path('../../test_helper', __FILE__)

module PagarMe
  class TransactionTest < Test::Unit::TestCase

	should 'be able to charge' do
		transaction = test_transaction
		transaction.charge

		assert transaction.id

		assert transaction.card_holder_name
		assert transaction.status == 'paid'
		assert !transaction.refuse_reason 
		assert transaction.date_created
		assert transaction.amount == 1000
		assert transaction.installments == "1"
		assert transaction.card_holder_name == 'Jose da Silva'
		# assert transaction.card_brand == 'visa'
		assert transaction.payment_method == 'credit_card'
		assert !transaction.boleto_url
		assert !transaction.boleto_barcode
		assert !transaction.subscription_id
	end

  end
end
