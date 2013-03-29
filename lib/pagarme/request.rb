require 'uri'
require 'rest_client'
require 'multi_json'
require File.join(File.dirname(__FILE__), '.', 'utils')

module PagarMe
  class Request
	attr_accessor :path, :method, :parameters, :headers

	def initialize(path, method)
	  self.path = path
	  self.method = method
	  self.parameters = {}
	  self.headers = {}
	end

	def run
	  unless PagarMe.api_key
		raise "You need to configure a API key before performing requests."
	  end

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
		  error = "Unexpected response code (#{e.inspect})."
		else
		  raise
		end
	  rescue RestClient::ExceptionWithResponse => e
		if e.http_code and e.http_body
		  parsed_error = parse_json_response(e.http_body)
		  if parsed_error['error']
			error = "Response error (#{e.http_code}): #{parsed_error['error']}"
		  else
			error = "Invalid response code (#{e.http_code})."
		  end
		else
		  error = "Unexpected response code (#{e.message} - #{e.http_code})"
		end
	  rescue RestClient::Exception, Errno::ECONNREFUSED => e
		puts "conn refused error #{e}"
		# self.handle_restclient_error(e)
		error = "Error connecting to server: connection refused"
	  end

	  raise error if error

	  parse_json_response(response.body)
	end

	private

	def parse_json_response(response)
	  begin
		MultiJson.load(response)
	  rescue MultiJson::LoadError => e
		raise "Error: #{e.message} - Invalid response from server: #{response}"
	  end
	end
  end
end
