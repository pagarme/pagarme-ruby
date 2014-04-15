# encoding: utf-8
require_relative '../test_helper'

module PagarMe
  class PlanTest < Test::Unit::TestCase
    should 'be able to create a plan' do
      plan = test_plan
      plan.create
      test_plan_response(plan)
    end

    should 'be able to update plan' do
      plan = test_plan
      plan.create
      plan.name = "plano silver"
      plan.save
      assert plan.name == 'plano silver'
    end

	should 'be able to search by anything' do
	  plan = test_plan
	  plan.create

	  plans = PagarMe::Plan.find_by({:trial_days => 5})

	  assert plans.size
	  plans.each do |p|
		assert p.trial_days == 5
	  end
	end

    should 'be able to create with unformatted amount' do
      plan = test_plan
      plan.amount = 'R$ 10.00'
      plan.create
      assert plan.amount == 1000
    end

    should 'validate plan' do
      exception = assert_raises PagarMeError do
        plan = Plan.new({
          :amount => -1
        })
        plan.create
      end
      assert exception.errors.first.parameter_name == 'amount'
      exception = assert_raises PagarMeError do
        plan = Plan.new({
          :amount => 1000,
          :days => -1,
        })
        plan.create
      end
      assert exception.errors.first.parameter_name == 'days'

      exception = assert_raises PagarMeError do
        plan = Plan.new({
          :amount => 1000,
          :days => 30,
        })
        plan.create
      end
      assert exception.errors.first.parameter_name == 'name'
      exception = assert_raises PagarMeError do
        plan = Plan.new({
          :amount => 1000,
          :days => 30,
          :name => "Plano Silver"
        })
        plan.create
        plan.days = 'Plano gold'
        plan.save
      end
      assert exception.errors.first.parameter_name == 'days'
    end
  end
end
