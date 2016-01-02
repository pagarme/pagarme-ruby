require_relative '../lib/pagarme'
require 'test/unit'
require 'shoulda'

def test_transaction(params = {})
  return PagarMe::Transaction.new({
    :card_number => "4901720080344448",
    :card_holder_name => "Jose da Silva",
    :card_expiration_month => "10",
    :card_expiration_year => "99",
    :card_cvv => "314",
    :amount => 1000
  }.merge(params))
end

def test_transfer(params = {})
  return PagarMe::Transfer.new({
    amount: 1000,
  }.merge(params))
end

def test_card(params = {})
  return PagarMe::Card.new({
	:card_number => '4111111111111111',
	:card_holder_name => 'Jose da Silva',
	:card_expiration_month => '10',
	:card_expiration_year => '99',
	:card_cvv => '314'
  }.merge(params))
end

def test_subscription_without_plan(params = {})
  return PagarMe::Subscription.new({
    :payment_method => 'credit_card',
    :card_number => "4901720080344448",
    :card_holder_name => "Jose da Silva",
    :card_expiration_month => "10",
    :card_expiration_year => "99",
    :card_cvv => "314",
    :postback_url => "http://test.com/postback",
    :customer => {
      :email => 'customer@pagar.me'
    }
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

def test_bank_account(params = {})
  return PagarMe::BankAccount.new({
    :bank_code => '237',
    :agencia => '1935',
    :agencia_dv => '9',
    :conta => '23398',
    :conta_dv => '9',
    :legal_name => 'foo bar loem',
    :document_number => '00000000000000'
  }.merge(params))
end

def test_subscription(params = {})
  return PagarMe::Subscription.new({
    :payment_method => 'credit_card',
    :card_number => "4901720080344448",
    :card_holder_name => "Jose da Silva",
    :card_expiration_month => "10",
    :card_expiration_year => "99",
    :card_cvv => "314",
    :postback_url => "http://test.com/postback",
    :customer => {
      email: 'customer@pagar.me'
    }
  }.merge(params))
end

def test_transaction_with_customer(params = {})
  return PagarMe::Transaction.new({
    :amount => 1000,
    :card_number => '4901720080344448',
    :card_holder_name => "Jose da Silva",
    :card_expiration_month => "11",
    :card_expiration_year => "99",
    :card_cvv => "356",
    :customer => {
      :name => "Jose da Silva",
      :document_number => "36433809847",
      :email => "henrique+test@pagar.me",
      :address => {
        :street => 'Av. Brigadeiro Faria Lima',
        :neighborhood => 'Itaim bibi',
        :zipcode => '01452000',
        :street_number => "2941",
      },
      :phone => {
        :ddd => "12",
        :number => '981433533',
      },
      :sex => 'M',
      :born_at => '1970-10-11'
    }
  }.merge(params))
end

def test_subscription_with_customer(params = {})
  return PagarMe::Subscription.new({
    :amount => 1000,
    :card_number => '4901720080344448',
    :card_holder_name => "Jose da silva",
    :card_expiration_month => "11",
    :card_expiration_year => "99",
    :card_cvv => "356",
    :customer => {
      :name => "Jose da Silva",
      :document_number => "36433809847",
      :email => "henrique@pagar.me",
      :address => {
        :street => 'Av. Brigadeiro Faria Lima',
        :neighborhood => 'Itaim bibi',
        :zipcode => '01452000',
        :street_number => "1000",
      } ,
      :phone => {
        :ddd => "12",
        :number => '981444444',
      } ,
      :sex => 'M',
      :born_at => '1970-10-11'
    }
  }.merge(params))
end


def test_customer_response(customer)
  assert customer.id
  assert customer.document_type == 'cpf'
  assert customer.name == 'Jose da Silva'
  assert customer.born_at
  assert customer.id
end

def test_subscription_transaction_response(transaction, amount = nil, installments = nil)
	amount ||= 2000
	installments ||= 1
  assert transaction.id
  assert !transaction.refuse_reason
  assert transaction.date_created
  assert transaction.amount == amount
  assert transaction.installments.to_i == installments
  # assert transaction.card_brand == 'visa'
  assert transaction.payment_method == 'credit_card'
  assert transaction.status == 'paid'
  assert !transaction.boleto_url
  assert !transaction.boleto_barcode
end

def test_transaction_response(transaction)
  assert transaction.id
  assert transaction.card_holder_name
  assert !transaction.refuse_reason
  assert transaction.date_created
  assert transaction.amount == 1000
  assert transaction.installments.to_i == 1
  assert transaction.card_holder_name == 'Jose da Silva'
  # assert transaction.card_brand == 'visa'
  assert transaction.payment_method == 'credit_card'
  assert transaction.status == 'paid'
end

def test_plan_response(plan)
  assert plan.id
  assert plan.name == 'Plano gold'
  assert plan.trial_days == 5
  assert plan.days == 30
  assert plan.amount = 3000
end

class Test::Unit::TestCase
  def setup
    PagarMe.api_key="ak_test_Rw4JR98FmYST2ngEHtMvVf5QJW7Eoo"
  end

  def teardown
    PagarMe.api_key=nil
  end
end
