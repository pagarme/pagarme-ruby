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
      raise PagarMe::RequestError, 'You need to configure a API key before performing requests.' unless PagarMe.api_key

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

        if error.is_a? RestClient::ResourceNotFound
          if parsed_error['errors']
            raise PagarMe::NotFound.new(parsed_error, request_params, error)
          else
            raise PagarMe::NotFound.new(nil, request_params, error)
          end
        else
          if parsed_error['errors']
            raise PagarMe::ValidationError.new parsed_error
          else
            raise PagarMe::ResponseError.new(request_params, error)
          end
        end
      rescue MultiJson::ParseError
        raise PagarMe::ResponseError.new(request_params, error)
      end
    rescue MultiJson::ParseError
      raise PagarMe::ResponseError.new(request_params, response)
    rescue SocketError
      raise PagarMe::ConnectionError.new $!
    rescue RestClient::ServerBrokeConnection
      raise PagarMe::ConnectionError.new $!
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

    def self.delete(url, options={})
      self.new url, 'DELETE', options
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
