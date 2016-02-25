require_relative '../../test_helper'

module PagarMe
  class RecipientTest < Test::Unit::TestCase

    should 'be able to create a recipient with bank_account data' do
      recipient = PagarMe::Recipient.create recipient_with_nested_bank_account_params
      assert_not_nil recipient.date_created
    end

    should 'be able to create a recipient with bank_account id' do
      bank_account = PagarMe::BankAccount.create bank_account_params
      recipient    = PagarMe::Recipient.create recipient_params(bank_account_id: bank_account.id)

      assert_not_nil recipient.date_created
    end

    should 'not be able to create a recipient without bank_account data' do
      recipient = PagarMe::Recipient.new recipient_params
      exception = assert_raises(PagarMe::ValidationError){ recipient.create }

      [:bank_code, :agencia, :conta_dv, :conta, :document_number, :legal_name].each do |missing_attr|
        assert_has_error_param exception, "bank_account[#{missing_attr}]"
      end
      assert_nil recipient.date_created
    end

    should 'be able to search' do
      recipient = PagarMe::Recipient.create recipient_with_nested_bank_account_params

      bank_account_doc_number = bank_account_params[:document_number]
      recipients = PagarMe::Recipient.find_by 'bank_account[document_number]' => bank_account_doc_number

      assert recipients.size > 0
      recipients.each do |recipient|
        assert_equal recipient.bank_account.document_number, bank_account_doc_number
      end
    end

  end
end
