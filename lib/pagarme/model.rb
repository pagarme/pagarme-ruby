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
		raise PagarMeError.new("ID invalido", 'id') if !self.id
	  "#{self.class.url}/#{CGI.escape(id.to_s)}"
	end

	def create
	  request = PagarMe::Request.new(self.class.url, 'POST')
	  request.parameters = self.to_hash
	  response = request.run
	  update(response)
	end

	def save
	  request = PagarMe::Request.new(self.url, 'PUT')
	  request.parameters = self.to_hash
	  response = request.run
	  update(response)
	end


	def self.find_by_id(id)
	  request = PagarMe::Request.new(self.url + "/#{id}", 'GET')
	  response = request.run
	  PagarMe::Util.convert_to_pagarme_object(response)
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
