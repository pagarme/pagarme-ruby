require_relative '../test_helper'

module PagarMe
  class ObjectTest < Test::Unit::TestCase
    should 'be able to create object and add any attribute' do
      object = PagarMe::PagarMeObject.new({
        :attr1 => 2
      })

      assert object.attr1 == 2

      object = PagarMe::PagarMeObject.new
      object.attr1 = 2

      assert object.attr1 == 2
    end

    should 'be able to add nested attributes' do
      object = PagarMe::PagarMeObject.new({
        :nested => {
          :attr => 2
        }
      })

      assert object.nested.attr = 2
    end
  end
end
