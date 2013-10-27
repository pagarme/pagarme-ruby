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
		self.pagarme_classes.fetch(response['object'], PagarMeObject).construct_from(response)
	  else
		response
	  end
	end

	def self.url_encode(key)
	  URI.escape(key.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
	end

	def self.flatten_params(params, parent_key=nil)
	  result = []
	  params.each do |key, value|
		calculated_key = parent_key ? "#{parent_key}[#{url_encode(key)}]" : url_encode(key)
		if value.is_a?(Hash)
		  result += flatten_params(value, calculated_key)
		elsif value.is_a?(Array)
		  result += flatten_params_array(value, calculated_key)
		else
		  result << [calculated_key, value]
		end
	  end
	  result
	end

	def self.flatten_params_array(value, calculated_key)
	  result = []
	  value.each do |elem|
		if elem.is_a?(Hash)
		  result += flatten_params(elem, calculated_key)
		elsif elem.is_a?(Array)
		  result += flatten_params_array(elem, calculated_key)
		else
		  result << ["#{calculated_key}[]", elem]
		end
	  end
	  result
	end
  end

end

class Hash
  def to_params
	self.collect{ |key, value| "#{key}=#{value}" }.join('&')
  end
end

