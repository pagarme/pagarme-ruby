require File.join(File.dirname(__FILE__), '.', 'lib/pagarme')

transaction = PagarMe::Transaction.new

puts transaction.live_mode
