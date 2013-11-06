# encoding: utf-8
require File.join(File.dirname(__FILE__), '..', 'pagarme')

module PagarMe
  class Plan < Model

	def initialize(response = {})
	  super
	  before_set_filter :amount, :format_amount
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
	  error = PagarMeError.new
	  if !self[:amount] || self.amount.to_i <= 0
		error.errors << PagarMeError.new('Valor invalido', 'amount')
	  end
	  if !self[:days] || self.days.to_i <= 0
		error.errors << PagarMeError.new('Numero de dias invalido', 'days')
	  end
	  if !self[:name] || self.name.length <= 0
		error.errors << PagarMeError.new('Nome invalido', 'name')
	  end
	  if self[:trial_days] && self.trial_days.to_i < 0
		error.errors << PagarMeError.new('Dias de teste invalido', 'trial_days')
	  end

	  if(error.errors.any?)
		error.message = error.errors.map {|e| e.message}
		error.message = error.message.join(',')
		raise error
	  else
		nil
	  end
	end

  end
end
