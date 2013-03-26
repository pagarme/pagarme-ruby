require 'uri'

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
		end

		private
		
		def join_parameters_in_payload
			URI.escape(self.parameters.collect{ |key, value| "#{key}=#{value}" }.join('&'))
		end
	end
end
