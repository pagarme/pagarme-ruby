# encoding: utf-8
require 'openssl'
require 'base64'
require File.join(File.dirname(__FILE__), '..', 'pagarme')

module PagarMe
  class Transaction < TransactionCommon
	# server requests methods

	def to_hash
	  {
		:amount => self.amount,
		:payment_method => self.payment_method,
		:installments => self.installments,
		:card_hash => (self.payment_method == 'credit_card' ? self.card_hash : nil),
		:postback_url => self.postback_url,
		:customer => (self.customer) ? self.customer.to_hash : nil
	  }
	end

	def charge
	  validation_error = self.card_hash ? nil : error_in_transaction
	  raise RequestError.new(validation_error) if validation_error
	  raise RequestError.new("Transaction already charged!") if self.status != 'local' && self.status
	  self.card_hash = generate_card_hash unless self.card_hash
	  create
	end

	def refund
	  raise RequestError.new("Transação já estornada") if self.status == 'refunded'
	  raise RequestError.new("Transação precisa estar paga para ser estornada") if self.status != 'paid'
	  raise RequestError.new("Boletos não pode ser estornados") if self.payment_method != 'credit_card'

	  request = PagarMe::Request.new(self.url + '/refund', 'POST')
	  response = request.run
	  update(response)
	end
  end
end
