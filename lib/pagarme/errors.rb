module PagarMe
  class PagarMeError < StandardError
  end

  class ConnectionError < PagarMeError
    attr_reader :error

    def initialize(error)
      @error = error
      super error.message
    end
  end

  class RequestError < PagarMeError
  end

  class ResponseError < PagarMeError
    attr_reader :request_params, :error

    def initialize(request_params, error)
      @request_params, @error = request_params, error
      super @error.message
    end
  end

  class NotFound < ResponseError
    attr_reader :response
    def initialize(response, request_params, error)
      @response = response
      super request_params, error
    end
  end

  class ValidationError < PagarMeError
    attr_reader :response, :errors

    def initialize(response)
      @response = response
      @errors   = response['errors'].map do |error|
        params = error.values_at('message', 'parameter_name', 'type', 'url')
        ParamError.new(*params)
      end
      super @errors.map(&:message).join(', ')
    end

    def to_h
      @errors.map(&:to_h)
    end
  end

  class ParamError < PagarMeError
    attr_reader :parameter_name, :type, :url

    def initialize(message, parameter_name, type, url)
      @parameter_name, @type, @url = parameter_name, type, url
      super message
    end

    def to_h
      { parameter_name: parameter_name , type: type , message: message }
    end
  end
end
