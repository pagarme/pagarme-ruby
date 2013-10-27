# encoding: utf-8
require File.join(File.dirname(__FILE__), '..', 'pagarme')

module PagarMe
  class TransactionCommon < Model

	def initialize(response = {})
	  super(response)
	  self.payment_method = 'credit_card' unless self.payment_method
	  self.installments = 1 unless self.installments
	end

	def is_valid_credit_card(card)
	  s1 = s2 = 0
	  card.to_s.reverse.chars.each_slice(2) do |odd, even| 
		s1 += odd.to_i

		double = even.to_i * 2
		double -= 9 if double >= 10
		s2 += double
	  end
	  (s1 + s2) % 10 == 0
	end

	def error_in_transaction
	  if self.amount.to_i <= 0
		"Valor inválido."
	  end

	  if self.payment_method == 'credit_card'
		if self.card_number.length < 16 || self.card_number.length > 20 || !is_valid_credit_card(self.card_number)
		  "Número do cartão inválido."
		elsif self.card_holder_name.length == 0
		  "Nome do portador inválido."
		elsif self.card_expiracy_month.to_i <= 0 || self.card_expiracy_month.to_i > 12
		  "Mês de expiração inválido."
		elsif self.card_expiracy_year.to_i <= 0
		  "Ano de expiração inválido."
		elsif self.card_cvv.length < 3 || self.card_cvv.length > 4
		  "Código de segurança inválido."
		else
		  nil
		end
	  end
	end

	def card_data_parameters
	  {
		:card_number => self.card_number,
		:card_holder_name => self.card_holder_name,
		:card_expiracy_date => "#{self.card_expiracy_month}#{self.card_expiracy_year}",
		:card_cvv => self.card_cvv
	  }
	end

	def generate_card_hash
	  request = PagarMe::Request.new("/transactions/card_hash_key", 'GET')
	  response = request.run

	  public_key = OpenSSL::PKey::RSA.new(response['public_key'])
	  ret = "#{response['id']}_#{Base64.strict_encode64(public_key.public_encrypt(card_data_parameters.to_params))}"
	end
  end
end
