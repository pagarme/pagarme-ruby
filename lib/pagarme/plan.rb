# encoding: utf-8
require File.join(File.dirname(__FILE__), '..', 'pagarme')

module PagarMe
  class Plan < Model
	
	def initialize(response = {})
	  super
	  before_set_filter :amount, :format_amount
	  add_unmutable_attribute :amount, :days, :color
	end

	def create
	  validate
	  super
	end

	def save
	  raise PagarMeError.new('O plano precisa estar criado para poder ser atualizado!', 'internal_error') unless self.id
	  super
	end

	def format_amount(amount)
	  if amount.kind_of?(String)
		value = amount.gsub(/\./, "")
		value = value.strip
		value = value.match(/\d+/)[0]
		amount = value
	  end
	  amount
	end

	private

	def validate
	  if !self.amount || self.amount.to_i <= 0
		raise PagarMeError.new('Valor invalido', 'amount')
	  elsif !self.days|| self.days.to_i <= 0
		raise PagarMeError.new('Numero de dias invalido', 'days')
	  elsif !self.name || self.name.length <= 0
		raise PagarMeError.new('Nome invalido', 'name')
	  elsif self.trial_days && self.trial_days.to_i < 0
		raise PagarMeError.new('Dias de teste invalido', 'trial_days')
	  end
	end
  end
end
