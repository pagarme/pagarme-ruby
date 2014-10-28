# encoding: utf-8
require_relative '../test_helper'

module PagarMe
  class CardTest < Test::Unit::TestCase
	should 'be able to create' do
	  card = test_card
	  card.create

	  assert card.id
	  assert card.first_digits == '411111'
	  assert card.last_digits = '1111'
	end

	should 'be able to find by id' do
	  card = test_card
	  card.create

	  card2 = PagarMe::Card.find_by_id(card.id)

	  assert card.id == card2.id
	  assert card.first_digits == card2.first_digits
	  assert card.last_digits == card2.last_digits
	end
  end
end
