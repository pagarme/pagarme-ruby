# encoding: utf-8
require File.join(File.dirname(__FILE__), '..', 'pagarme')

module PagarMe
  class Subscription < TransactionCommon


	def create
	  if self.plan
		self.plan_id = plan.id
	  end

	  self.plan = nil
	  super
	end

	def save
	  if self.plan
		self.plan_id = plan.id
	  end

	  self.plan = nil
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
