module PagarMe
  class Recipient < Model
    def balance
      PagarMe::Balance.find_by_recipient_id id
    end

    def balance_operations(*args)
      PagarMe::BalanceOperation.find_by_recipient_id id, *args
    end

    def receive(amount)
      PagarMe::Transfer.create recipient_id: id, amount: amount
    end
  end
end
