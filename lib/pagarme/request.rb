require 'uri'
require 'rest_client'
require 'multi_json'
require File.join(File.dirname(__FILE__), '.', 'utils')
require File.join(File.dirname(__FILE__), '.', 'errors')

module PagarMe
  class Request
	attr_accessor :path, :method, :parameters, :headers, :live

	def initialize(path, method, live=PagarMe.live)
	  self.path = path
	  self.method = method
	  self.live = live
	  self.parameters = {}
	  self.headers = {}
	end

	def run
	  unless PagarMe.api_key
		raise PagarMeError.new("You need to configure a API key before performing requests.")
	  end

	  self.headers = self.live ? { 'X-Live' => '1' } : {}

	  parameters = self.parameters.merge({
		:api_key => PagarMe.api_key
	  })

	  error = nil

	  begin
		response = RestClient::Request.execute({
		  :method => self.method,
		  :url => PagarMe.full_api_url(self.path),
		  :headers => self.headers,
		  :open_timeout => 30,
		  :payload => parameters.to_params,
		  :timeout => 90,
		  :verify_ssl => false # TODO: change to verify SSL
		})
	  rescue SocketError => e
		error = "Error connecting to server (#{e.message})."
	  rescue NoMethodError => e
		if e.message =~ /\WRequestFailed\W/
		  raise ResponseError.new("Unexpected response code (#{e.inspect}).")
		else
		  raise
		end
	  rescue RestClient::ExceptionWithResponse => e
		if e.http_code and e.http_body
		  parsed_error = parse_json_response(e.http_body)
		  if parsed_error['error']
			error = parsed_error
			raise PagarMeError.initFromServerResponse(error)
		  else
			error = "Invalid response code (#{e.http_code})."
			raise PagarMeError.new(message)
		  end
		else
		  raise PagarMeError.new("Unexpected response code (#{e.message} - #{e.http_code})")
		end
	  rescue RestClient::Exception, Errno::ECONNREFUSED => e
		error = "Error connecting to server: connection refused"
	  end

	  raise ConnectionError.new(error) if error

	  parse_json_response(response.body)
	end

	private

	def parse_json_response(response)
	  begin
		MultiJson.load(response)
	  rescue MultiJson::LoadError => e
		raise PagarMeError.new("Server response is not a valid JSON.")
	  end
	end
  end
end
