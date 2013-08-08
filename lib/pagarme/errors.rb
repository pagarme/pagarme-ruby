module PagarMe
  class PagarMeError < StandardError
	attr_reader :message
	attr_reader :original_error

	def initialize(message=nil, original_error=nil)
	  @message = message
	  @original_error = original_error
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
