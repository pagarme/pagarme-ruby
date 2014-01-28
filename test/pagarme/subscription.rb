# encoding: utf-8
require_relative '../test_helper'

module PagarMe
  class SubscriptionTest < Test::Unit::TestCase
	should 'be able to create subscription with plan' do
	  plan = test_plan
	  plan.create
	  subscription = test_subscription
	  subscription.plan = plan
	  subscription.create
	  test_plan_response(subscription.plan)
	  test_transaction_with_customer(subscription)
	end

	should 'be able to create subscription without plan' do
	  subscription = test_subscription({:amount => 2000})
	  subscription.create
	  assert subscription.transactions.length == 1
	  subscription.charge(2000)
	  assert subscription.transactions.length == 2
	  assert subscription.transactions.first.kind_of?(PagarMe::Transaction)
	  subscription.transactions.each do |t|
		test_subscription_transaction_response(t)
	  end
	end

	should 'be able to change plans' do
	  subscription = test_subscription
	  plan = test_plan
	  plan.create

	  plan2 = PagarMe::Plan.new({
		:name => "Plano Silver",
		:days => 30,
		:amount => 3000
	  });
	  plan2.create

	  subscription.plan = plan
	  subscription.create

	  assert subscription.plan.id == plan.id
	  subscription.plan = plan2
	  subscription.save

	  assert subscription.plan.id == plan2.id
	end

	should 'be able to cancel a subscription' do
	  subscription = test_subscription
	  plan = test_plan
	  plan.create

	  subscription.plan = plan
	  subscription.create

	  subscription.cancel

	  assert subscription.status == 'canceled'
	end
  end
end
