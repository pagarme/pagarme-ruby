module PagarMe
  class Util
	def self.pagarme_classes
	  return {
	  	'transaction' => Transaction,
		'plan' => Plan,
		'customer' => Customer,
		'subscription' => Subscription,
		'address' => Address,
		'phone' => Phone,
	  }
	end


	def self.convert_to_pagarme_object(response)
	  case response
	  when Array
		response.map{ |i| convert_to_pagarme_object(i)}
	  when Hash
		self.pagarme_classes.fetch(response[:object], PagarMeObject).construct_from(response)
	  else
		response
	  end
	end
  end


end
