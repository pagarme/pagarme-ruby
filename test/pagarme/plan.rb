require File.expand_path('../../test_helper', __FILE__)
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

	should 'be able to create with unformatted amount' do
	  plan = test_plan
	  plan.amount = 'R$ 10.00'
	  plan.create
	  assert plan.amount == 1000
	end
  end
end
