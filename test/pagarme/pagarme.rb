# encoding: utf-8
require_relative '../test_helper'

module PagarMe
  class PagarMeTest < Test::Unit::TestCase
		should 'validate fingerprint correctly' do
		 	assert PagarMe::validate_fingerprint(123, Digest::SHA1.hexdigest( "123" + "#" + PagarMe::api_key)) == true
		end
  end
end
