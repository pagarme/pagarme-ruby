require File.join(File.dirname(__FILE__), '..', 'pagarme')

module PagarMe
  class TransactionCommon < Model

  def initialize(response = {})
    super(response)
    self.payment_method = 'credit_card' unless self.payment_method
    self.installments = 1  unless self.installments
    self.status = 'local' unless self.status
  end

  def create
    check_card_object
    clear_card_data
    super
  end

  def save
    check_card_object
    clear_card_data
    super
  end

  def card_data_parameters
    {
      :card_number => self.card_number,
      :card_holder_name => self.card_holder_name,
      :card_expiration_date => "#{self.card_expiration_month}#{self.card_expiration_year}",
      :card_cvv => self.card_cvv
    }
  end

  def generate_card_hash
    request = PagarMe::Request.new("/transactions/card_hash_key", 'GET')
    response = request.run

    public_key = OpenSSL::PKey::RSA.new(response['public_key'])
    ret = "#{response['id']}_#{Base64.strict_encode64(public_key.public_encrypt(card_data_parameters.to_params))}"
  end

  def should_generate_card_hash
    true
  end

  private
    def check_card_object
    if self.card
      if self.card.id
      self.card_id = self.card.id
      else
      self.card_number = self.card.card_number
      self.card_holder_name = self.card.card_holder_name
      self.card_expiration_year = self.card.card_expiration_year
      self.card_expiration_month = self.card.card_expiration_month
      self.card_cvv = self.card.card_cvv
      end
      self.card = nil
    end
    end

    def clear_card_data
    if self.should_generate_card_hash
      self.card_hash = generate_card_hash unless self.card_hash || self.card_id
      self.card_number = nil
      self.card_holder_name = nil
      self.card_expiration_year = nil
      self.card_expiration_month = nil
      self.card_cvv = nil
    end
    end
  end
end
