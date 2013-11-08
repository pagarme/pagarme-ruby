# encoding: utf-8
require File.join(File.dirname(__FILE__), '..', 'pagarme')

module PagarMe
  class Subscription < TransactionCommon

	def to_hash
	  {
		:amount => self.amount,
		:payment_method => self.payment_method,
		:installments => self.installments,
		:card_hash => (self.payment_method == 'credit_card' ? self.card_hash : nil),
		:postback_url => self.postback_url,
		:customer_email => self.customer_email,
		:customer => (self.customer) ? self.customer.to_hash : nil,
		:plan_id => (self.plan) ? self.plan.id : nil
	  }
	end

	def create
	  validation_error = self.card_hash ? nil : validate
	  self.card_hash = generate_card_hash unless self.card_hash
	  super
	end

	def charge(amount)
	  request = PagarMe::Request.new(self.url, 'POST')
	  request.parameters = {
		:amount => amount,
	  }
	  response = request.run
	  update(response)
	end

  end
end
