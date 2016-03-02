module PagarMe
  class BalanceOperation < PagarMeObject

    def method_missing(name, *args, &block)
      if @attributes['movement_object'] && @attributes['movement_object'].respond_to?(name)
        return movement_object.public_send(name, *args, &block)
      end

      super name, *args, &block
    end

    class << self
      def url(recipient_id = nil)
        if recipient_id
          "/recipients/#{recipient_id}/balance/operations"
        else
          '/balance/operations'
        end
      end

      def balance_operations(page = 1, count = 10)
        raise RequestError.new('Invalid page count') if page < 1 or count < 1

        params = { page: page, count: count }
        PagarMe::Request.get(url, params: params).call
      end

      def find_by_recipient_id(recipient_id, page = 1, count = 10)
        raise RequestError.new('Invalid ID') unless recipient_id.present?

        params = { page: page, count: count }
        PagarMe::Request.get(url(recipient_id), params: params).call
      end
    end

  end
end
