module PagarMe
  class PaymentLink < Model
    def cancel()
      update PagarMe::Request.post(url('cancel')).run
    end
  end
end
