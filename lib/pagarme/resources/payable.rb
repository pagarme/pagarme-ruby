module PagarMe
  class Payable < Model
    def transaction
      @transaction ||= PagarMe::Transaction.find transaction_id
    end

    def recipient
      @recipient ||= PagarMe::Recipient.find recipient_id
    end
  end
end
