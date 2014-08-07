# encoding: utf-8
require_relative '../test_helper'

module PagarMe
  class UtilTest < Test::Unit::TestCase

    should 'calculate installments' do
      installments_result = PagarMe::Util.calculate_installments({
        amount: 10000,
        interest_rate: 0
      })

      assert installments_result['installments'].size == 12
      assert installments_result['installments']['2']['installment_amount'] == 5000
    end

  end
end
