require_relative '../../test_helper'

module PagarMe
  class CustomerTest < PagarMeTestCase
    should 'be able to create' do
      customer = PagarMe::Customer.create external_id_customer_params[:customer]
      assert       customer.id
      assert_equal customer.name, 'Morpheus Fishburne'
      assert_equal customer.type, 'individual'
      assert_equal customer.external_id, "#3311"
      assert_equal customer.country, 'br'
      assert_equal customer.birthday, "1965-01-01"
      assert       customer.phone_numbers.any?
      assert_equal customer.phone_numbers, ["+5511999998888", "+5511888889999"]
    end

    should 'be able to find by id' do
      customer       = PagarMe::Customer.create external_id_customer_params[:customer]
      found_customer = PagarMe::Customer.find_by_id customer.id
      assert_equal customer.id, found_customer.id
    end
  end
end
