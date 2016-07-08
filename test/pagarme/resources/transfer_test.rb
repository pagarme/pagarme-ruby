require_relative '../../test_helper'

module PagarMe
  class TransferTest < PagarMeTestCase
    def setup
      super
      ensure_positive_balance
    end

    should 'be able to create a transfer' do
      transfer = PagarMe::Transfer.create transfer_params
      assert_transfer transfer
    end

    should 'be able to find with id' do
      transfer = PagarMe::Transfer.create transfer_params
      assert_transfer transfer

      found_transfer = PagarMe::Transfer.find_by_id transfer.id
      assert_transfer found_transfer
    end
  end
end
