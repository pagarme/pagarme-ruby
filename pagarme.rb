require File.join(File.dirname(__FILE__), '.', 'lib/pagarme')

PagarMe.api_key = "Jy1V5bJcGf8q4gHepttt"

transaction = PagarMe::Transaction.new

transaction.card_number = "0000000000000000"
transaction.card_holder_name = "Test User"
transaction.card_expiracy_month = "12"
transaction.card_expiracy_year = "15"
transaction.card_cvv = "314"
transaction.live = false

transaction.charge

transaction.chargeback

chargebacked_transaction = PagarMe::Transaction.find_by_id(transaction.id)

puts chargebacked_transaction.id == transaction.id
puts chargebacked_transaction.status == transaction.status
