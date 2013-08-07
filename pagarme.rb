require File.join(File.dirname(__FILE__), '.', 'lib/pagarme')

PagarMe.api_key = "4f0907cdfaf855b83a5d4a83a247772f"
PagarMe.live = true

begin
  transaction = PagarMe::Transaction.new
  transaction.payment_method = 'boleto'
  transaction.card_number = "0000000000000000"
  transaction.card_holder_name = "Test User"
  transaction.card_expiracy_month = "12"
  transaction.card_expiracy_year = "15"
  transaction.card_cvv = "314"
  transaction.amount = 1000
  transaction.charge
  puts transaction
  puts transaction.payment_method
  puts transaction.status

  # transaction.chargeback

  # chargebacked_transaction = PagarMe::Transaction.find_by_id(transaction.id)
  # puts chargebacked_transaction.id == transaction.id
  # puts chargebacked_transaction.status == transaction.status
  # puts chargebacked_transaction.inspect

  # puts "\n\n"

  # hash_transaction = PagarMe::Transaction.new({
	# :card_number => "0000000000000000",
	# :card_holder_name => "Test User",
	# :card_expiracy_month => "12",
	# :card_expiracy_year => "13",
	# :card_cvv => "314",
	# :amount => 10000,
	# :installments => 5
  # })
  # hash_transaction.charge
  # puts hash_transaction.inspect
  # puts hash_transaction.status

  # puts "\n\n"
  # 
  # transactions = PagarMe::Transaction.all
  # puts transactions.inspect
rescue PagarMe::PagarMeError => e
  puts "Error: #{e}"
end
