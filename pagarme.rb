require File.join(File.dirname(__FILE__), '.', 'lib/pagarme')
transaction = PagarMe::Transaction.new
transaction.card_number = "4901720080344448"
transaction.card_holder_name = "Jose da Silva"
transaction.card_expiration_month = "13" # o mês 13 é maior do que 12 (dezembro) -> parâmetro inválido!
transaction.card_expiration_year = "15"
transaction.card_cvv = "314"
transaction.amount = 1000

transaction.charge


