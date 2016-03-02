module PagarMe
  class Zipcode < PagarMeObject
    ZIPCODE_REGEXP = /\d{5}[-\.\_\s]?\d{3}/

    def self.find(zipcode)
      raise PagarMe::RequestError.new('invalid zipcode') unless valid_zipcode?(zipcode)
      sanitized_zipcode = zipcode.gsub(/[-\.\_\s]/, '')
      self.new PagarMe::Request.get("/zipcodes/#{sanitized_zipcode}").run
    end

    def self.valid_zipcode?(zipcode)
      zipcode.match ZIPCODE_REGEXP
    end
  end
end
