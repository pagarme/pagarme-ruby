require_relative '../../test_helper'

module PagarMe
  class SubscriptionTest < PagarMeTestCase
    should 'be able to create subscription with plan' do
      plan = PagarMe::Plan.create plan_params
      assert_plan_created plan

      subscription = PagarMe::Subscription.create subscription_with_customer_params(plan: plan)
      assert_subscription_created subscription, plan
    end

    should 'be able to see subscription transactions' do
      plan         = PagarMe::Plan.create no_trial_plan_params
      subscription = PagarMe::Subscription.create subscription_with_customer_params(plan: plan)
      assert_no_trial_subscription_created subscription, plan

      sleep 1
      assert       subscription.transactions.count > 0
      assert_equal subscription.transactions.first.status, 'paid'
    end

    should 'be able to create subscription with plan and unsaved card' do
      plan         = PagarMe::Plan.create plan_params
      card         = PagarMe::Card.new card_params
      subscription = PagarMe::Subscription.create subscription_with_customer_params(plan: plan, card: card)
      assert_subscription_created subscription, plan
    end

    should 'be able to create subscription with plan and saved card' do
      plan         = PagarMe::Plan.create plan_params
      card         = PagarMe::Card.create card_params
      subscription = PagarMe::Subscription.create subscription_with_customer_params(plan: plan, card: card)
      assert_subscription_created subscription, plan
    end

    should 'be able to create subscription without plan' do
      subscription = PagarMe::Subscription.create subscription_with_customer_with_card_params(amount: 2000)
      assert_subscription_successfully_paid subscription, 2000

      found_subscription = PagarMe::Subscription.find_by_id subscription.id
      assert_subscription_successfully_paid found_subscription, 2000
    end

    should 'be able to create subscription without plan and charge with installments' do
      subscription = PagarMe::Subscription.create subscription_with_customer_with_card_params(amount: 2000, installments: 6)
      assert_subscription_successfully_paid subscription, 2000, 6

      id = subscription.id

      subscription.charge 1500, 3
      assert_equal id, subscription.id
      assert_subscription_successfully_paid subscription, 1500, 3

      found_subscription = PagarMe::Subscription.find_by_id subscription.id
      assert_subscription_successfully_paid found_subscription, 1500, 3
    end

    should 'be able to update subscription' do
      subscription = PagarMe::Subscription.create subscription_with_customer_with_card_params

      subscription.payment_method = 'boleto'
      subscription.save

      found_subscription = PagarMe::Subscription.find_by_id subscription.id
      assert_equal found_subscription.payment_method, 'boleto'
    end

    should 'raise an error when nil or empty string as ID' do
      assert_raises RequestError do
        PagarMe::Subscription.find_by_id nil
      end

      assert_raises RequestError do
        PagarMe::Subscription.find_by_id ''
      end
    end

    should 'be able to change plans' do
      plan       = PagarMe::Plan.create plan_params
      other_plan = PagarMe::Plan.create other_plan_params

      subscription = PagarMe::Subscription.create subscription_with_customer_with_card_params(plan: plan)
      assert_equal subscription.plan.id, plan.id

      subscription.plan = other_plan
      subscription.save
      assert_equal subscription.plan.id, other_plan.id
    end

    should 'be able to cancel a subscription' do
      plan         = PagarMe::Plan.create plan_params
      subscription = PagarMe::Subscription.create subscription_with_customer_with_card_params(plan: plan)
      assert_equal subscription.status, 'trialing'

      subscription.cancel
      assert_equal subscription.status, 'canceled'
    end

    should 'be able to settle_charge a subscription' do
      plan         = PagarMe::Plan.create no_trial_plan_params
      subscription = PagarMe::Subscription.create boleto_with_customer_params(plan: plan)
      assert_equal subscription.status, 'unpaid'

      subscription.settle_charge
      assert_equal subscription.status, 'paid'
    end
  end
end
