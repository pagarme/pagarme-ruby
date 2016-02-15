require 'uri'
require 'rest_client'
require 'multi_json'

module PagarMe
  class Request
    attr_accessor :path, :method, :parameters, :headers, :query

    SSL_CA_FILEPATH = File.join File.dirname(__FILE__), '..', '..', 'certs', 'cabundle.pem'
    DEFAULT_HEADERS = {
      'Content-Type' => 'application/json; charset=utf8',
      'Accept'       => 'application/json',
      'User-Agent'   => "pagarme-ruby/#{PagarMe::VERSION}"
    }

    def initialize(path, method, options={})
      raise RequestError, 'You need to configure a API key before performing requests.' unless PagarMe.api_key

      @path       = path
      @method     = method
      @parameters = options[:params]  || Hash.new
      @query      = options[:query]   || Hash.new
      @headers    = options[:headers] || Hash.new
    end

    def run
      response = RestClient::Request.execute request_params
      MultiJson.decode response.body
    rescue RestClient::Exception => error
      begin
        parsed_error = MultiJson.decode error.http_body

        if parsed_error['errors']
          raise ValidationError.new parsed_error
        else
          raise ResponseError.new(request_params, error)
        end
      rescue MultiJson::ParseError
        raise ResponseError.new(request_params, error)
      end
    rescue MultiJson::ParseError
      raise ResponseError.new(request_params, response)
    rescue SocketError
      raise ConnectionError.new $!
    rescue RestClient::ServerBrokeConnection
      raise ConnectionError.new $!
    end

    def call
      PagarMeObject.convert run
    end

    def self.get(url, options={})
      self.new url, 'GET', options
    end

    def self.post(url, options={})
      self.new url, 'POST', options
    end

    def self.put(url, options={})
      self.new url, 'PUT', options
    end

    protected
    def request_params
      {
        method:       method,
        user:         PagarMe.api_key,
        password:     'x',
        url:          full_api_url,
        payload:      MultiJson.encode(parameters),
        open_timeout: PagarMe.open_timeout,
        timeout:      PagarMe.timeout,
        ssl_ca_file:  SSL_CA_FILEPATH,
        headers:      DEFAULT_HEADERS.merge(headers)
      }
    end

    def full_api_url
      url = PagarMe.api_endpoint + path

      if !query.nil? && !query.empty?
        url += '?' + URI.encode_www_form(query)
      end

      url
    end
  end
end
