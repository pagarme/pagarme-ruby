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
		:postback_url => self[:postback_url],
		:customer => (self.customer) ? self.customer.to_hash : nil
	  }
	end

	def charge
	  validation_error = self[:card_hash] ? nil : validate
	  self.card_hash = generate_card_hash unless self[:card_hash]
	  create
	end

	def refund
	  request = PagarMe::Request.new(self.url + '/refund', 'POST')
	  response = request.run
	  update(response)
	end
  end
end
