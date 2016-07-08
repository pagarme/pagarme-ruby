require_relative '../../test_helper'

module PagarMe
  class ZipcodeTest < PagarMeTestCase
    should 'be able find a zipcode' do
      zipcode = PagarMe::Zipcode.find '12228-462'

      assert_equal zipcode.city,         'São José dos Campos'
      assert_equal zipcode.neighborhood, 'Campus do CTA'
      assert_equal zipcode.state,        'SP'
      assert_equal zipcode.street,       'Rua H8C'
      assert_equal zipcode.zipcode,      '12228462'
    end
  end
end
