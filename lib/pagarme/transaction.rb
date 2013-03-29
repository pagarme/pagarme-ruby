require 'openssl'
require 'base64'
require File.join(File.dirname(__FILE__), '..', 'pagarme')
require File.join(File.dirname(__FILE__), '.', 'utils')

module PagarMe
  class Transaction
	attr_accessor :amount, :card_number, :card_holder_name, :card_expiracy_month, :card_expiracy_year, :card_cvv

	def initialize
	  @statuses_codes = { :local => 0, :approved => 1, :processing => 2, :refused => 3, :chargebacked => 4 }
	  @environments_codes = { :production => 1, :development => 2 }
	  @status = 0
	  @environment = @environments_codes[:production]

	  self.amount = 1000
	  self.card_number = self.card_holder_name = self.card_expiracy_month = self.card_expiracy_year = self.card_cvv = ""
	end

	def status
	  @statuses_codes.key(@status)
	end

	def live_mode=(is_live)
	  @environment = is_live ? @environments_codes[:production] : @environments_codes[:development]
	end

	def live_mode
	  @environment == @environments_codes[:production]
	end

	# server requests methods

	def charge
	  validation_error = error_in_card_data
	  raise validation_error if validation_error

	  request = PagarMe::Request.new('/transactions', 'POST')
	  request.parameters = {
		:amount => self.amount.to_s,
		:card_hash => generate_card_hash
	  }

	  request.run
	end

	private

	def error_in_card_data
	  if self.card_number.length < 16 || self.card_number.length > 20
		"Invalid card number."
	  elsif self.card_holder_name.length == 0
		"Invalid card holder name."
	  elsif self.card_expiracy_month.to_i <= 0 || self.card_expiracy_month.to_i > 12
		"Invalid expiracy date month."
	  elsif self.card_expiracy_year.to_i <= 0
		"Invalid expiracy date year."
	  elsif self.card_cvv.length < 3 || self.card_cvv.length > 4
		"Invalid card security code."
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
	  public_key = OpenSSL::PKey::RSA.new(File.read(PagarMe.api_card_encryption_public_key))
	  Base64.strict_encode64(public_key.public_encrypt(card_data_parameters.to_params))
	end
  end
end
