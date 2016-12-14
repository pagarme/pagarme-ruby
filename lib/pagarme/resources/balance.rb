module PagarMe
  class Balance < PagarMeObject

    class << self
      def url(recipient_id = nil)
        if recipient_id
          "/recipients/#{recipient_id}/balance"
        else
          '/balance'
        end
      end

      def balance
        PagarMe::Request.get(url).call
      end

      def find_by_recipient_id(recipient_id = nil)
        raise IdMustBeInformed.new unless recipient_id.present?
        PagarMe::Request.get(url recipient_id).call
      end
    end

  end
end
