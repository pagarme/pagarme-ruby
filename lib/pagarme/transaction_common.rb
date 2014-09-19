# encoding: utf-8
require File.join(File.dirname(__FILE__), '..', 'pagarme')

module PagarMe
  class TransactionCommon < Model

    def initialize(response = {})
      super(response)
      self.payment_method = 'credit_card' unless self.payment_method
      self.installments = 1  unless self.installments
      self.status = 'local' unless self.status
    end

    def create
      self.card_hash = generate_card_hash unless self.card_hash
      self.card_number = nil
      self.card_holder_name = nil
      self.card_expiration_year = nil
      self.card_expiration_month = nil
      self.card_cvv = nil
      super
    end

    def card_data_parameters
      {
        :card_number => self.card_number,
        :card_holder_name => self.card_holder_name,
        :card_expiration_date => "#{self.card_expiration_month}#{self.card_expiration_year}",
        :card_cvv => self.card_cvv
      }
    end

    def generate_card_hash
      request = PagarMe::Request.new("/transactions/card_hash_key", 'GET')
      response = request.run
	  card_data = {
        :card_number => self.card_number,
        :card_holder_name => self.card_holder_name,
        :card_expiration_date => "#{self.card_expiration_month}#{self.card_expiration_year}",
        :card_cvv => self.card_cvv
      }

      public_key = OpenSSL::PKey::RSA.new(response['public_key'])
      ret = "#{response['id']}_#{Base64.strict_encode64(public_key.public_encrypt(card_data.to_params))}"
    end
  end
end
