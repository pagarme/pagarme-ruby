require_relative '../../test_helper'

module PagarMe
  class BulkAnticipationTest < PagarMeTestCase

    def setup
      super
      ensure_anticipable_default_recipient
      ensure_waiting_funds
    end

    should 'be able to calculate anticipations limits' do
      assert_anticipation_limits PagarMe::Recipient.default.bulk_anticipations_limits(anticipations_limits_params)
    end

    should 'be able to request anticipation and cancel it' do
      recipient    = PagarMe::Recipient.default
      anticipation = recipient.bulk_anticipate anticipation_params

      assert_anticipation anticipation
      assert_anticipation BulkAnticipation.find(recipient.id, anticipation.id)

      anticipation.cancel
      assert_canceled_anticipation anticipation

      anticipation = recipient.bulk_anticipate anticipation_params
      assert_canceled_anticipation PagarMe::BulkAnticipation.cancel(recipient.id, anticipation.id)
    end

    should 'have bulk anticipations on default recipient ' do
      recipient = PagarMe::Recipient.default
      assert recipient.bulk_anticipations.count > 0
    end

    protected
    def anticipation_params(params = Hash.new)
      anticipations_limits_params(reasonable_amount).merge params
    end

    def reasonable_amount
      limits = PagarMe::Recipient.default.bulk_anticipations_limits(anticipations_limits_params)
      { requested_amount: (limits.maximum.amount + 9*limits.minimum.amount)/10 + 1 }
    end

  end
end
