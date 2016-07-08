require_relative '../../test_helper'

module PagarMe
  class BankAccountTest < PagarMeTestCase
    should 'be able to create a bank_account' do
      bank_account = PagarMe::BankAccount.create bank_account_params
      assert_equal bank_account.bank_code, '237'
    end

    should 'be able to search by anything' do
      PagarMe::BankAccount.create bank_account_params
      bank_accounts = PagarMe::BankAccount.find_by bank_code: '237'

      assert bank_accounts.size > 0
      bank_accounts.each do |bank_account|
        assert_equal bank_account.bank_code, '237'
      end
    end

    {
      bank_code:       'foo',
      agencia:         'abcd',
      agencia_dv:      'Y',
      conta:           'ABCD',
      conta_dv:        'X',
      legal_name:      'John Doe',
      document_number: '02476585700'
    }.each do |key, value|
      should "validate bank_account - #{key}" do
        exception = assert_raises(PagarMe::ValidationError){ BankAccount.create key => value }
        assert_hasnt_error_param exception, key.to_s
      end
    end
  end
end
