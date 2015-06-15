require_relative '../test_helper'

module PagarMe
  class TransferTest < Test::Unit::TestCase
    should 'be able to create a transfer' do
      bank_account = test_bank_account
      bank_account.create
      transfer = test_transfer(bank_account_id: bank_account.id)
      transfer.create

      assert transfer.id != nil
      assert transfer.fee != nil
      assert transfer.object == "transfer"
      assert %w(doc credito_em_conta ted).include?(transfer.type)
      assert transfer.bank_account.id.to_i == bank_account.id.to_i
    end

    should 'be able to find with id' do
      bank_account = test_bank_account
      bank_account.create
      transfer_r = test_transfer(bank_account_id: bank_account.id)
      transfer_r.create

      transfer = PagarMe::Transfer.find_by_id transfer_r.id

      assert transfer.id != nil
      assert transfer.fee != nil
      assert transfer.object == "transfer"
      assert %w(doc credito_em_conta ted).include?(transfer.type)
      assert transfer.bank_account.id.to_i == bank_account.id.to_i
    end
  end
end

