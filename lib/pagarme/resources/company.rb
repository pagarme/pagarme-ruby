module PagarMe
  class Company < PagarMeObject
    def default_recipient
      PagarMe::Recipient.find default_recipient_by_env
    end

    protected
    def default_recipient_by_env
      if PagarMe.production?
        default_recipient_id.live
      else
        default_recipient_id.test
      end
    end

    def self.default_recipient
      company.default_recipient
    end

    def self.company
      PagarMe::Request.get('/company').call
    end

    def self.temporary
      PagarMe::Request.post('/companies/temporary').call
    end
  end
end
