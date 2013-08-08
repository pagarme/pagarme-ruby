# encoding: utf-8
require File.join(File.dirname(__FILE__), '..', 'pagarme')

module PagarMe
  class Subscription < TransactionCommon
	attr_accessor :plan, :id, :postback_url, :current_period_start, :current_period_end, :status, :date_created, :customer_email
	@root_url = '/subscriptions'

	def initialize(hash = nil, server_response = nil)
	  hash = {} unless hash

	  self.payment_method = 'credit_card'

	  self.plan = hash[:plan]
	  self.postback_url = hash[:postback_url]
	  self.payment_method = hash[:payment_method]
	  self.customer_email = hash[:customer_email]

	  self.fill_fields_from_hash(hash) if hash

	  update_fields_from_response(server_response) if server_response
	end

	def create
	  validation_error = self.card_hash ? nil : error_in_transaction
	  raise RequestError.new(validation_error) if validation_error
	  raise RequestError.new("Subscription já criado.") if self.id

	  request = PagarMe::Request.new('/subscriptions', 'POST')
	  request.parameters = {
		:amount => self.amount.to_s,
		:payment_method => self.payment_method,
		:card_hash => self.payment_method == 'credit_card' ? (self.card_hash ? self.card_hash : generate_card_hash) : nil,
		:postback_url => self.postback_url,
		:customer_email => self.customer_email
	  }

	  request.parameters[:plan_id] = self.plan.id if self.plan

	  puts request.parameters.inspect

	  response = request.run
	  update_fields_from_response(response)
	end

	def charge(amount)
	  raise RequestError.new("Subscription não é variável") if self.plan

	  request = PagarMe::Request.new("/subscriptions/#{self.id}", 'POST')
	  request.parameters = {
		:amount => amount,
	  }

	  response = request.run
	  update_fields_from_response(response)
	end

	def update_fields_from_response(response)
	  if(response['plan'])
		@plan = PagarMe::Plan.new(nil, response['plan'])
	  end
	  @id = response['id'];
	  @postback_url = response['postback_url'];
	  @current_period_start = response['current_period_start'];
	  @current_period_end = response['current_period_end'];
	  @status = response['status'];
	  @customer_email = response['status'];
	  @transactions = response['transactions'].map { |transaction| PagarMe::Transaction.new(nil, transaction) }
	end
  end
end
