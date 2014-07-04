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

	def cancel
	  request = PagarMe::Request.new(self.url + '/cancel', 'POST')
	  response = request.run
	  update(response)
	end

	def transactions
	  request = PagarMe::Request.new(self.url + '/transactions', 'GET')
	  PagarMe::Util.convert_to_pagarme_object(request.run)
	end

	def charge(amount)
	  request = PagarMe::Request.new(self.url + '/transactions', 'POST')
	  request.parameters = {
		:amount => amount,
	  }
	  response = request.run

	  request = PagarMe::Request.new(self.url, 'GET')
	  update(request.run)
	end

  end
end
