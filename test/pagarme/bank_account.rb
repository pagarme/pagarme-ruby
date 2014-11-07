# encoding: utf-8
require_relative '../test_helper'

module PagarMe
  class BankAccountTest < Test::Unit::TestCase
    should 'be able to create a bank_account' do
      bank_account = test_bank_account
      bank_account.create

      assert bank_account.bank_code == '237'
    end

    should 'be able to search by anything' do
      bank_account = test_bank_account()
      bank_account.create

      bank_accounts = PagarMe::BankAccount.find_by({ bank_code: '237' })

      assert bank_accounts.size
      bank_accounts.each do |b|
        assert b.bank_code == '237'
      end
    end

    [
      { bank_code: 'foo' },
      { agencia: 'abcd' },
      { agencia_dv: 'Y'},
      { conta: 'ABCD' },
      { conta_dv: ''},
      { legal_name: '' },
      { document_number: 'foooo'}
    ].each do |attrs|
      attr_key = attrs.keys.first

      should "validate bank_account - #{attr_key.to_s}" do
        exception = assert_raises PagarMeError do
          bank_account = BankAccount.new(attrs)
          bank_account.create
        end

        assert exception.errors.map(&:parameter_name).include?(attr_key.to_s)
      end
    end
  end
end
