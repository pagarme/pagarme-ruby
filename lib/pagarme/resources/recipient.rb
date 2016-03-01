module PagarMe
  class Recipient < Model
    def bulk_anticipations_limits(params = Hash.new)
      PagarMe::BulkAnticipation.bulk_anticipations_limits id, params
    end

    def bulk_anticipations(page = 1, count = 10)
      raise RequestError.new('Invalid page count') if page < 1 or count < 1
      PagarMe::BulkAnticipation.all id, page, count
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
