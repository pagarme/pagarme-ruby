require_relative '../../test_helper'

module PagarMe
  class CardTest < PagarMeTestCase
    should 'be able to create' do
      card = PagarMe::Card.create card_params

      assert       card.id
      assert_equal card.first_digits, '490172'
      assert_equal card.last_digits,  '4448'
    end

    should 'be able to find by id' do
      card       = PagarMe::Card.create card_params
      found_card = PagarMe::Card.find_by_id card.id

      assert_equal card.id,           found_card.id
      assert_equal card.first_digits, found_card.first_digits
      assert_equal card.last_digits,  found_card.last_digits
    end
  end
end
