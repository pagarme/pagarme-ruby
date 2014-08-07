# encoding: utf-8
require 'openssl'
require 'base64'
require File.join(File.dirname(__FILE__), '..', 'pagarme')

module PagarMe
  class Transaction < TransactionCommon
    def charge
      create
    end

    def refund
      request = PagarMe::Request.new(self.url + '/refund', 'POST')
      response = request.run
      update(response)
    end
  end
end
