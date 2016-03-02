module PagarMe
  class Postback < PagarMeObject
    def valid?
      self.class.validate id, fingerprint
    end

    def self.validate(id, fingerprint)
      fingerprint_for(id) == fingerprint
    end

    def self.fingerprint_for(id)
      Digest::SHA1.hexdigest id.to_s + "#" + PagarMe.api_key
    end
  end
end
