module PagarMe
  class Transaction < TransactionCommon
    alias :charge :create

    def capture(params={})
      update PagarMe::Request.post(url('capture'), params: params).run
    end

    def refund(params={})
      update PagarMe::Request.post(url('refund'), params: params).run
    end

    class << self
      def calculate_installments(params)
        PagarMe::Request.get(url('calculate_installments_amount'), query: params).run
      end

      alias :charge :create
    end
  end
end
