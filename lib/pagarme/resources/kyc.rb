module PagarMe
  class Kyc < PagarMeObject
    class << self
      def parent_resource_name
        'recipients'
      end

      def url(recipient_id)
        ["/#{parent_resource_name}", recipient_id, "kyc_link"].join '/'
      end

      def create_link(recipient_id)
        raise RequestError.new('Invalid ID') unless recipient_id.present?
        PagarMe::Request.post( url(recipient_id) ).call
      end
    end
  end
end
