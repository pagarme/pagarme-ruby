require File.join(File.dirname(__FILE__), '.', 'lib/pagarme')

PagarMe.api_key = "Jy1V5bJcGf8q4gHepttt"
PagarMe.live = true

begin
  transaction = PagarMe::Transaction.new
  transaction.card_number = "0000000000000000"
  transaction.card_holder_name = "Test User"
  transaction.card_expiracy_month = "12"
  transaction.card_expiracy_year = "15"
  transaction.card_cvv = "314"
  transaction.amount = 1000
  transaction.charge
  transaction.chargeback

  chargebacked_transaction = PagarMe::Transaction.find_by_id(transaction.id)
  puts chargebacked_transaction.id == transaction.id
  puts chargebacked_transaction.status == transaction.status
  puts chargebacked_transaction.inspect

  puts "\n\n"

  card_hash_transaction = PagarMe::Transaction.new("bQQfLVIs0UB5qR28Cx3flweO5aIm9clBVJdlbgBHmKC418YVvrZR4tDBsuERitydeDqMqk6dXYWTHit4u2kHTOepqyXaKTuJVasYL6IiC0lEDhkRxcqbJeOKAAjsru4vTTP3V0XftAVwZ9ehFoGFTEZCnDFus3SSvZrY27HjOJ+VepWDzP4yq46A8n8RR9h6WhD3CmqYNSGOCvJGA5hO0j3CFQGFqcX1gQP7QUQwncEmZYVYjXG7B2W+jFTovjm/1DicmPcdHXxfHbtt7osgo/d4JYmM44BeNg6FzqSzphOuM+zceCu+Pn1QrRXJxUPi2DRSXnvz2EQjqdTyENK/hA==")
  card_hash_transaction.amount = 1000
  card_hash_transaction.charge
  puts card_hash_transaction.inspect

  puts "\n\n"

  hash_transaction = PagarMe::Transaction.new({
	:card_number => "0000000000000000",
	:card_holder_name => "Test User",
	:card_expiracy_month => "12",
	:card_expiracy_year => "13",
	:card_cvv => "314",
	:amount => 1000
  })
  hash_transaction.charge
  puts hash_transaction.inspect
  puts hash_transaction.status

  puts "\n\n"
  
  transactions = PagarMe::Transaction.all
  puts transactions.inspect
rescue PagarMe::PagarMeError => e
  puts "Error: #{e}"
end
