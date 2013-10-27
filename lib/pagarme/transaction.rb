# encoding: utf-8
require 'openssl'
require 'base64'
require File.join(File.dirname(__FILE__), '..', 'pagarme')

module PagarMe
  class Transaction < TransactionCommon

	# server requests methods

	def charge
	  validation_error = self.card_hash ? nil : error_in_transaction
	  raise RequestError.new(validation_error) if validation_error
	  raise RequestError.new("Transaction already charged!") if self.status != 'local' && self.status

	  request = PagarMe::Request.new(self.class.url, 'POST')
	  self.card_hash = generate_card_hash unless self.card_hash
	  request.parameters = {
		:amount => self.amount.to_s,
		:payment_method => self.payment_method,
		:installments => self.installments.to_i,
		:card_hash => self.payment_method == 'credit_card' ? self.card_hash : nil,
		:postback_url => self.postback_url
	  }

	  response = request.run
	  refresh_from(response)
	end

	def chargeback
	  raise RequestError.new("Transaction already chargebacked!") if @status == 'chargebacked'
	  raise RequestError.new("Transaction needs to be paid to be chargebacked") if @status != 'paid'
	  raise RequestError.new("Boletos não podem ser cancelados") if self.payment_method != 'credit_card'

	  request = PagarMe::Request.new("/transactions/#{self.id}", 'DELETE')
	  response = request.run
	  update_fields_from_response(response)
	end
  end
end
