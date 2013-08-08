# encoding: utf-8

require 'base64'
require File.join(File.dirname(__FILE__), '..', 'pagarme')
require File.join(File.dirname(__FILE__), '.', 'utils')
require File.join(File.dirname(__FILE__), '.', 'errors')

module PagarMe
  class Plan < Model
	attr_accessor :id, :amount, :days, :name, :trial_days
	@root_url = '/plans'
	
	def initialize(hash = nil, server_response = nil)
	  hash = {} unless hash

	  self.amount = hash[:amount] || 0
	  self.days = hash[:days] || 0
	  self.name = hash[:name] || ''
	  self.trial_days = hash[:trial_days] || 0

	  update_fields_from_response(server_response) if server_response
	end

	def create
	  validate

	  request = PagarMe::Request.new('/plans', 'POST')
	  request.parameters = {
		:amount => self.amount,
		:days => self.days,
		:name => self.name,
		:trial_days => self.trial_days
	  }

	  response = request.run
	  update_fields_from_response(response)
	end

	def amount=(new_amount)
	  raise "'amount' não pode ser editado!" if self.id
	end

	def days=(new_days)
	  raise "'days' não pode ser editado!" if self.id
	end

	def update
	  validate
	  raise "O plano precisa estar criado para poder ser atualizado!" unless self.id

	  request = PagarMe::Request.new('/plans/' + self.id.to_s, 'PUT')
	  request.parameters = {
		:name => self.name,
		:trial_days => self.trial_days
	  }

	  response = request.run
	  update_fields_from_response(response)
	end

	def update_fields_from_response(server_response)
	  @amount = server_response['amount']
	  @days = server_response['days']
	  @name = server_response['name']
	  @trial_days = server_response['trial_days']
	  @id = server_response['id']
	end

	private

	def validate
	  raise "'amount' inválido" if self.amount <= 0
	  raise "'days' inválido" if self.days <= 0
	  raise "'name' inválido" if self.name.length <= 0
	  raise "'trial_days' inválido" if self.trial_days < 0
	end
  end
end
