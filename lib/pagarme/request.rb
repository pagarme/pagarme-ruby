require 'uri'
require 'rest_client'
require 'multi_json'
require File.join(File.dirname(__FILE__), '.', 'util')
require File.join(File.dirname(__FILE__), '.', 'errors')

module PagarMe
	class Request
		attr_accessor :path, :method, :parameters, :headers, :query

		def initialize(path, method)
			self.path = path
			self.method = method
			self.parameters = {}
			self.query = {}
			self.headers = {}
		end

		def run
			raise PagarMeError, "You need to configure a API key before performing requests." unless PagarMe.api_key

			begin
				response = RestClient::Request.execute({
					:method => self.method,
					:user => PagarMe.api_key,
					:password => 'x',
					:url => PagarMe.full_api_url(self.path) + '?' + URI.encode_www_form(query),
					:payload => MultiJson.encode(parameters),
					:open_timeout => PagarMe.open_timeout,
					:timeout => PagarMe.timeout,
					:ssl_ca_file => File.join(File.dirname(__FILE__), '..', '..', 'certs', 'cabundle.pem'),
					:headers => {
						'Content-Type' => 'application/json; charset=utf8',
						'Accept' => 'application/json',
						'User-Agent' => 'pagarme-ruby/1.0'
					}
				})
			rescue RestClient::ExceptionWithResponse => e
				parsed_error = MultiJson.decode(e.http_body)

				if parsed_error['errors']
					raise PagarMeError.fromServerResponse(parsed_error)
				else
					raise PagarMeError.new(e.http_body)
				end
			end

			MultiJson.decode response.body
		end
	end
end
