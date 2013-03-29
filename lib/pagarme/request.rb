require 'uri'
require 'rest_client'
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
				puts "error socket #{e}"
				# self.handle_restclient_error(e)
			rescue NoMethodError => e
				# Work around RestClient bug
				if e.message =~ /\WRequestFailed\W/
					# e = APIConnectionError.new('Unexpected HTTP response code')
					# self.handle_restclient_error(e)
					puts "Error NoMethodError #{e}"
				else
					raise
				end
			rescue RestClient::ExceptionWithResponse => e
				if rcode = e.http_code and rbody = e.http_body
					puts "rcode #{rcode} - rbody: #{rbody}"
					# self.handle_api_error(rcode, rbody)
				else
					puts "nothing to show error e: #{e}"
					# self.handle_restclient_error(e)
				end
			rescue RestClient::Exception, Errno::ECONNREFUSED => e
				puts "conn refused error #{e}"
				# self.handle_restclient_error(e)
			end


			puts response.inspect
		end
	end
end
