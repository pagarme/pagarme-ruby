require_relative '../test_helper'

module PagarMe
  class PagarMeTest < Test::Unit::TestCase
    should 'validate fingerprint correctly' do
      finderprint = Digest::SHA1.hexdigest "123##{PagarMe.api_key}"
      assert PagarMe.validate_fingerprint(123, finderprint)
    end
  end
end
