# encoding: utf-8
require_relative '../test_helper'

module PagarMe
  class TransferTest < Test::Unit::TestCase
		def setup
			super

			t = PagarMe::Transaction.new({
				:payment_method => 'boleto',
				:amount => 10000
			})

			t.charge
			t.status = 'paid'
			t.save
		end

    should 'be able to create a transfer' do
      transfer = test_transfer
      transfer.create

      assert transfer.id != nil
      assert transfer.fee != nil
      assert transfer.object == "transfer"
      assert %w(doc credito_em_conta ted).include?(transfer.type)
    end

    should 'be able to find with id' do
      transfer_r = test_transfer
      transfer_r.create

      transfer = PagarMe::Transfer.find_by_id transfer_r.id

      assert transfer.id != nil
      assert transfer.fee != nil
      assert transfer.object == "transfer"
      assert %w(doc credito_em_conta ted).include?(transfer.type)
    end
  end
end

