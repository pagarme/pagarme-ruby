module PagarMe
  class Model < PagarMeObject

	def self.class_name
	  self.name.split('::')[-1]
	end

	def self.url()
	  if self == Model
		raise PagarMeError.new('Cant request for model')
	  end
	  "/#{CGI.escape(class_name.downcase)}s"
	end

	def url
	  unless id = self['id']
		raise PagarMeError.new("ID invalido", 'id')
	  end
	  "/#{self.class.url}/#{CGI.escape(id)}"
	end

	def create
	  request = PagarMe::Request.new(self.class.url, 'POST')
	  request.parameters = @values
	  response = request.run
	  refresh_from(response)
	end

	def self.find_by_id(id)
	  request = PagarMe::Request.new("#{url}/#{id}", 'GET')
	  response = request.run
	  object = self.new(response)
	  object.refresh_from(resposne)
	end

	def self.all(page = 1, count = 10)
	  raise RequestError.new("Invalid page count") if page < 1 or count < 1

	  request = PagarMe::Request.new(url, 'GET')
	  request.parameters = {
		:page => page,
		:count => count
	  }

	  response = request.run
	  response.map { |obj_response| self.new(obj_response) }
	end
  end
end
