module PagarMe
  class Model
	attr_accessor :root_url

	def self.find_by_id(id)
	  request = PagarMe::Request.new("#{@root_url}/#{id}", 'GET')
	  response = request.run
	  self.new(nil, response)
	end

	def self.all(page = 1, count = 10)
	  raise RequestError.new("Invalid page count") if page < 1 or count < 1

	  request = PagarMe::Request.new(@root_url, 'GET')
	  request.parameters = {
		:page => page,
		:count => count
	  }

	  response = request.run
	  response.map { |obj_response| self.new(nil, obj_response) }
	end
  end
end
