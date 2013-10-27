# require File.join(File.dirname(__FILE__), '.', '../lib/pagarme')
require 'pagarme'
require 'test/unit'
require 'shoulda'


def test_transaction(params = {})
  return PagarMe::Transaction.new({
	:card_number => "4901720080344448",
	:card_holder_name => "Jose da Silva",
	:card_expiracy_month => "10",
	:card_expiracy_year => "15",
	:card_cvv => "314",
	:amount => 1000
  }.merge(params))
end

def test_subscription_without_plan(params = {})
  return PagarMe::Subscription.new({
	:payment_method => 'credit_card',
	:card_number => "4901720080344448",
	:card_holder_name => "Jose da Silva",
	:card_expiracy_month => "10",
	:card_expiracy_year => "15",
	:card_cvv => "314",
	:customer_email => 'test@test.com',
	:postback_url => "http://test.com/postback"
  }.merge(params))
end 

def test_plan(params = {})
  return PagarMe::Plan.new({
	:name => "Plano gold",
	:trial_days => 5,
	:days => 30,
	:amount => 3000,	
  }.merge(params))
end


def test_subscription_with_plan(params = {})
  plan = test_plan
  return PagarMe::Subscription.new({
	:payment_method => 'credit_card',
	:card_number => "4901720080344448",
	:card_holder_name => "Jose da Silva",
	:card_expiracy_month => "10",
	:card_expiracy_year => "15",
	:card_cvv => "314",
	:customer_email => 'test@test.com',
	:postback_url => "http://test.com/postback",
	:plan => plan
  }.merge(params))
end

def test_transaction_with_customer(params = {})
  return PagarMe::Transaction.new({
	:amount => 70000,
	:card_number => '4901720080344448', 
	:card_holder_name => "Jose da silva", 
	:card_expiracy_month => 11, 
	:card_expiracy_year => "13", 
	:card_cvv => 356, 
	:customer => { 
	  :name => "Jose da Silva",  
	  :document_number => "36433809847", 
	  :email => "henrique@pagar.me", 
	  :address => {
		:street => 'Av. Brigadeiro Faria Lima', 
		:neighborhood => 'Itaim bibi',
		:zipcode => '01452000', 
		:street_number => 2941, 
	  },
	  :phone => {
		:ddd => 12, 
		:number => '981433533', 
	  },
	  :sex => 'M', 
	  :born_at => '1970-10-11'	
	}
  }.merge(params))
end

def test_subscription_with_customer(params = {})
  return PagarMe::Subscription.new({
	:amount => 70000,
	:card_number => '4901720080344448', 
	:card_holder_name => "Jose da silva", 
	:card_expiracy_month => 11, 
	:card_expiracy_year => "13", 
	:card_cvv => 356, 
	:customer_email => 'teste@teste.com',
	:customer => { 
	  :name => "Jose da Silva",  
	  :document_number => "36433809847", 
	  :email => "henrique@pagar.me", 
	  :address => {
		:street => 'Av. Brigadeiro Faria Lima', 
		:neighborhood => 'Itaim bibi',
		:zipcode => '01452000', 
		:street_number => 2941, 
	  } ,
	  :phone => { 
		:ddd => 12, 
		:number => '981433533', 
	  } ,
	  :sex => 'M', 
	  :born_at => '1970-10-11'	
	}
  }.merge(params))
end

class Test::Unit::TestCase
  setup do
    PagarMe.api_key="ak_test_Rw4JR98FmYST2ngEHtMvVf5QJW7Eoo"
  end

  teardown do
    PagarMe.api_key=nil
  end
end
