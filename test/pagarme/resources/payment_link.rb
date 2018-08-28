require_relative '../../test_helper'

module PagarMe
  class PaymentLinkTest < PagarMeTestCase
    should 'be able to create a payment_link' do
      payment_link = PagarMe::PaymentLink.create payment_link_params
      assert_equal payment_link.amount, 1000
    end

    should 'be able to cancel a payment_link' do
      payment_link = PagarMe::PaymentLink.create payment_link_params
      payment_link.cancel
      assert_equal payment_link.status, 'canceled'
    end

    should 'be able to search by short_id' do
      pl = PagarMe::PaymentLink.create payment_link_params
      payment_links = PagarMe::PaymentLink.find short_id: pl.short_id

      assert payment_links.size > 0
      payment_links.each do |payment_link|
        assert_equal payment_link.short_id, pl.short_id
      end
    end
  end
end
