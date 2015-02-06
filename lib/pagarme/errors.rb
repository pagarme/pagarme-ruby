module PagarMe
  class PagarMeError < StandardError
    attr_accessor :message
    attr_accessor :parameter_name
    attr_accessor :type
    attr_accessor :url
    attr_accessor :errors

    def initialize(message = "", parameter_name = "", type = "", url = "")
      self.message = message
      self.type = type
      self.parameter_name = parameter_name
      self.errors = []
    end

    def self.fromServerResponse(response = {})
      object = self.new

      object.message += response['errors'].map {|e| e['message'] }.join(", ")

      response['errors'].map do |error|
        object.errors << PagarMeError.new(error['message'],  error['parameter_name'], error['type'], response['url'])
      end

      object
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

