module PagarMe
  class BulkAnticipation < NestedModel
    def confirm
      update self.class.confirm(parent_id, id).attributes
      self
    end

    def delete
      self.class.delete parent_id, id
    end

    def cancel
      update self.class.cancel(parent_id, id).attributes
      self
    end

    class << self
      def parent_resource_name
        'recipients'
      end

      def confirm(recipient_id, id)
        PagarMe::Request.post( url(recipient_id, id, 'confirm') ).call
      end

      def delete(recipient_id, id)
        PagarMe::Request.delete( url(recipient_id, id) ).call
      end

      def cancel(recipient_id, id)
        PagarMe::Request.post( url(recipient_id, id, 'cancel') ).call
      end

      def create(params = Hash.new)
        super normalize_params(params)
      end

      def bulk_anticipations_limits(recipient_id, params = Hash.new)
        PagarMe::Request.get(url(recipient_id, 'limits'), params: normalize_params(params) ).call
      end

      protected
      def normalize_params(params = Hash.new)
        normalized_params = Hash[ params.map{ |key, value| [key.to_sym, value] } ]
        normalized_params[:timeframe]    = :start         if normalized_params[:timeframe].nil?    || normalized_params[:timeframe]    == ''
        normalized_params[:payment_date] = (Date.today+2) if normalized_params[:payment_date].nil? || normalized_params[:payment_date] == ''
        normalized_params[:payment_date] = date_to_milliseconds_since_epoch normalized_params[:payment_date]
        normalized_params
      end

      def date_to_milliseconds_since_epoch(date)
        case date
        when Date
          date.to_time.to_i * 1000
        when Time
          date.to_i * 1000
        else
          date
        end
      end
    end
  end
end
