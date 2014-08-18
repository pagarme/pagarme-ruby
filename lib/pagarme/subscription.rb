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

    def charge(amount, installments = 1)
      request = PagarMe::Request.new(self.url + '/transactions', 'POST')
      request.parameters = {
        :amount => amount,
				:installments => installments
      }
      response = request.run

      request = PagarMe::Request.new(self.url, 'GET')
      update(request.run)
    end

  end
end
