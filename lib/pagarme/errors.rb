module PagarMe
  class PagarMeError < StandardError
	attr_accessor :message
	attr_accessor :parameter_name
	attr_accessor :type
	attr_accessor :url
	attr_accessor :errors

	def initialize(message = "", url = "", parameter_name = "", type = "") 
	  self.message = message
	  self.type = type
	  self.parameter_name = parameter_name
	  self.errors = []
	end

	def self.initFromServerResponse(response = {})
		response.errors.map do |error|
		  self.message += error.message + ', '
		  self.errors << PagarMeError.new(error.message, response.url, error.parameter_name, error.type)
		end
	end
	
	def to_s
	  "#{self.class.to_s} - #{message}"
	end
  end

  class RequestError < PagarMeError
  end

  class ConnectionError < PagarMeError
  end

  class ResponseError < PagarMeError
  end
end
