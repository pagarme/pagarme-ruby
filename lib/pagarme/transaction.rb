# encoding: utf-8
require 'openssl'
require 'base64'
require File.join(File.dirname(__FILE__), '..', 'pagarme')

module PagarMe
  class Transaction < TransactionCommon
    def self.calculate_installments(params)
      request = PagarMe::Request.new('/transactions/calculate_installments_amount', 'GET')
      request.parameters.merge!(params)
      response = request.run
      response
    end

    def charge
      create
    end

	def capture(params={})
	  request = PagarMe::Request.new(self.url + '/capture', 'POST')
	  request.parameters.merge!(params)
	  response = request.run
	  update(response)
	end

    def refund(params={})
      request = PagarMe::Request.new(self.url + '/refund', 'POST')
	  request.parameters.merge!(params)
      response = request.run
      update(response)
    end
  end
end
