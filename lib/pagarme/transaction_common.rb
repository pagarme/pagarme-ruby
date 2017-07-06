module PagarMe
  class TransactionCommon < Model

    def initialize(response = {})
      super(response)

      self.payment_method ||= 'credit_card'
      self.installments   ||= 1
      self.status         ||= 'local'
    end

    def create
      check_card_object
      super
    end

    def save
      check_card_object
      super
    end

    def redeliver(id)
      update PagarMe::Request.post(url "postbacks/#{id}/redeliver").run
    end

    private
    def check_card_object
      if card
        if card.id
          self.card_id = self.card.id
        else
          self.card_number           = card.card_number
          self.card_holder_name      = card.card_holder_name
          self.card_expiration_year  = card.card_expiration_year
          self.card_expiration_month = card.card_expiration_month
          self.card_cvv              = card.card_cvv
          self.card_expiration_date  = "#{card_expiration_month}#{card_expiration_year}"
        end
        self.card = nil
      end

      self.card_expiration_date ||= "#{card_expiration_month}#{card_expiration_year}"
    end
  end
end
