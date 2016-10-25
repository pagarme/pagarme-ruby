module PagarMe
  class Recipient < Model
    def bulk_anticipations_limits(params = Hash.new)
      PagarMe::BulkAnticipation.bulk_anticipations_limits id, params
    end

    def bulk_anticipations(*args, **params)
      params = self.class.extract_page_count_or_params(*args, **params)
      raise RequestError.new('Invalid page count') if params[:page] < 1 or params[:count] < 1
      PagarMe::BulkAnticipation.all id, params
    end

    def bulk_anticipate(params = Hash.new)
      PagarMe::BulkAnticipation.create params.merge(parent_id: id)
    end

    def balance
      PagarMe::Balance.find_by_recipient_id id
    end

    def balance_operations(*args)
      PagarMe::BalanceOperation.find_by_recipient_id id, *args
    end

    def receive(amount)
      PagarMe::Transfer.create recipient_id: id, amount: amount
    end

    def self.default
      Company.default_recipient
    end
  end
end
