require_relative '../../test_helper'

module PagarMe
  class PlanTest < Test::Unit::TestCase
    should 'be able to create a plan' do
      plan = PagarMe::Plan.create plan_params
      assert_plan_created plan
    end

    should 'be able to update plan' do
      plan = PagarMe::Plan.create plan_params
      assert_plan_created plan

      plan.name = 'plano bronze'
      plan.save
      assert_equal plan.name, 'plano bronze'
    end

    should 'be able to search by anything' do
      plan = PagarMe::Plan.create plan_params
      assert_plan_created plan

      # find_by_hash is possibly consistent, wait to try to ensure!!!
      sleep 2
      found_plans = PagarMe::Plan.find_by trial_days: 5

      assert found_plans.size > 0
      found_plans.each do |plan|
        assert_equal plan.trial_days, 5
      end
    end

    should 'validate plan amount' do
      exception = assert_raises(PagarMe::ValidationError){ Plan.create amount: -1 }
      assert_has_error_param exception, 'amount'
    end

    should 'validate plan days' do
      exception = assert_raises(PagarMe::ValidationError){ Plan.create amount: 1000, days: -1 }
      assert_has_error_param exception, 'days'
    end

    should 'validate plan with missing name' do
      exception = assert_raises(PagarMe::ValidationError){ Plan.create amount: 1000, days: 20 }
      assert_has_error_param exception, 'name'
    end

    should 'not be possible to edit days' do
      plan = Plan.create amount: 1000, days: 20, name: 'Plano Platinum'
      exception = assert_raises(PagarMe::ValidationError) do
        plan.days = 30
        plan.save
      end
      assert_has_error_param exception, 'days'
    end
  end
end
