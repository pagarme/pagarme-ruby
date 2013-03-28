require 'uri'
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
			puts self.parameters.to_params.inspect
		end
	end
end
