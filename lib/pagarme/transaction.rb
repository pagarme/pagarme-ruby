# encoding: utf-8
require 'openssl'
require 'base64'
require File.join(File.dirname(__FILE__), '..', 'pagarme')
require File.join(File.dirname(__FILE__), '.', 'utils')
require File.join(File.dirname(__FILE__), '.', 'errors')

module PagarMe
  class Transaction
	attr_accessor :amount, :card_number, :card_holder_name, :card_expiracy_month, :card_expiracy_year, :card_cvv, :live, :card_hash, :installments

	# initializers

	def initialize(first_parameter = nil, server_response = nil)
	  @statuses_codes = { :local => 0, :approved => 1, :processing => 2, :refused => 3, :chargebacked => 4 }
	  @date_created = nil
	  @id = nil
	  self.status = :local
	  self.live = PagarMe.live
	  self.installments = 1

	  self.card_number = self.card_holder_name = self.card_expiracy_month = self.card_expiracy_year = self.card_cvv = ""
	  self.amount = 0

	  # First parameter can be a hash with transaction parameters
	  # or a encrypted card_hash that came from client.
	  if first_parameter.class == String
		self.card_hash = first_parameter
	  elsif first_parameter.class == Hash
		self.amount = first_parameter[:amount]
		self.card_number = first_parameter[:card_number]
		self.card_holder_name = first_parameter[:card_holder_name]
		self.card_expiracy_month = first_parameter[:card_expiracy_month]
		self.card_expiracy_year = first_parameter[:card_expiracy_year]
		self.card_cvv = first_parameter[:card_cvv]
		self.installments = first_parameter[:installments] if first_parameter[:installments]
		self.live = first_parameter[:live]
		self.live = PagarMe.live unless self.live
	  end

	  update_fields_from_response(server_response) if server_response
	end

	def self.find_by_id(id)
	  request = PagarMe::Request.new("/transactions/#{id}", 'GET')
	  response = request.run
	  PagarMe::Transaction.new(nil, response)
	end

	def self.all(page = 1, count = 10)
	  raise TransactionError.new("Invalid page count") if page < 1 or count < 1

	  request = PagarMe::Request.new('/transactions', 'GET')
	  request.parameters = {
		:page => page,
		:count => count
	  }

	  response = request.run
	  response.map { |transaction_response| PagarMe::Transaction.new(nil, transaction_response) }
	end

	# getters

	def status
	  @statuses_codes.key(@status)
	end

	def date_created
	  @date_created
	end

	def id
	  @id
	end

	# server requests methods

	def charge
	  validation_error = self.card_hash ? nil : error_in_transaction
	  raise TransactionError.new(validation_error) if validation_error
	  raise TransactionError.new("Transaction already charged!") if self.status != :local

	  request = PagarMe::Request.new('/transactions', 'POST', self.live)
	  request.parameters = {
		:amount => self.amount.to_s,
		:installments => self.installments.to_i,
		:card_hash => (self.card_hash ? self.card_hash : generate_card_hash)
	  }

	  response = request.run
	  update_fields_from_response(response)
	end

	def chargeback
	  raise TransactionError.new("Transaction already chargebacked!") if self.status == :chargebacked
	  raise TransactionError.new("Transaction needs to be approved to be chargebacked") if self.status != :approved

	  request = PagarMe::Request.new("/transactions/#{self.id}", 'DELETE', self.live)
	  response = request.run
	  update_fields_from_response(response)
	end


	private


	def status=(status)
	  @status = @statuses_codes[status]
	end

	def update_fields_from_response(response)
	  @status = @statuses_codes[response['status'].to_sym]
	  @date_created = response['date_created']
	  self.amount = response['amount']
	  self.live = response['live']
	  self.card_holder_name = response['costumer_name']
	  self.installments = (!response['installments'] ? 1 : response['installments'].to_i)
	  @id = response['id']
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
	  elsif self.amount.to_i <= 0
		"Valor inválido."
	  else
		nil
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
	  request = PagarMe::Request.new("/transactions/card_hash_key", 'GET', self.live)
	  response = request.run

	  public_key = OpenSSL::PKey::RSA.new(response['public_key'])
	  "#{response['id']}_#{Base64.strict_encode64(public_key.public_encrypt(card_data_parameters.to_params))}"
	end
  end
end
