module PagarMe
  class Postback < PagarMeObject
    def valid?
      self.class.valid_request_signature? payload, signature
    end

    def redirect(url = 'http://localhost:3000/pagarme/postback')
      uri = URI(url)
      Net::HTTP.new(uri.host, uri.port).post uri.path, payload, JSON.parse(headers)
    end

    class << self
      def valid_request_signature?(payload, signature)
        kind, raw_signature = signature.split '=', 2
        return false if kind.blank? || raw_signature.blank?
        signature(payload, kind) == raw_signature
      end
      alias :validate_request_signature :valid_request_signature?

      def signature(payload, hash_method = 'sha1')
        OpenSSL::HMAC.hexdigest hash_method, PagarMe.api_key, payload
      end

      # TODO: Remove deprecated Postback.validate
      def validate(id, fingerprint)
        $stderr.puts '[DEPRECATION WARNING] PagarMe.validate method is deprecated, use PagarMe.validate_request_signature instead'
        valid_request_signature? id, fingerprint
      end

      # TODO: Remove deprecated Postback.fingerprint_for
      def fingerprint_for(id)
        $stderr.puts '[DEPRECATION WARNING] PagarMe.fingerprint_for method is deprecated, use PagarMe.signature instead'
        signature id
      end
    end
  end
end
