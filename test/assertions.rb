module Assertions
  def assert_customer_response(customer)
    assert       customer.id
    assert_equal customer.name,                'Jose da Silva'
    assert_equal customer.document_number,     '36433809847'
    assert_equal customer.email,               'henrique+test@pagar.me'
    assert_equal customer.gender,              'M'
    assert_equal Date.parse(customer.born_at), Date.parse('1970-10-11')
  end

  def assert_subscription_successfully_paid(subscription, amount = 2000, installments = 1)
    assert       subscription.id
    assert       !subscription.plan
    assert       subscription.current_transaction.kind_of?(PagarMe::Transaction)
    assert       subscription.current_transaction.id
    assert       subscription.current_transaction.date_created
    assert       !subscription.current_transaction.refuse_reason
    assert       !subscription.current_transaction.boleto_url
    assert       !subscription.current_transaction.boleto_barcode
    assert_equal subscription.status,                             'paid'
    assert_equal subscription.current_transaction.amount,         amount
    assert_equal subscription.current_transaction.payment_method, 'credit_card'
    assert_equal subscription.current_transaction.status,         'paid'
    assert_equal subscription.current_transaction.card_brand,     'visa'
  end

  def assert_transaction_successfully_paid(transaction)
    assert       transaction.id
    assert       transaction.date_created
    assert       transaction.card.id
    assert       !transaction.refuse_reason
    assert_equal transaction.amount,            1000
    assert_equal transaction.installments.to_i, 1
    assert_equal transaction.card_holder_name,  'Jose da Silva'
    assert_equal transaction.payment_method,    'credit_card'
    assert_equal transaction.status,            'paid'
    assert_equal transaction.card_brand,        'visa'
    assert_equal transaction.card.first_digits, '490172'
    assert_equal transaction.card.last_digits,  '4448'
  end

  def assert_transaction_with_customer_successfully_paid(transaction)
    assert_transaction_successfully_paid transaction

    assert_equal transaction.customer.class, PagarMe::Customer
    assert_customer_response transaction.customer

    assert_equal transaction.phone.class,  PagarMe::Phone
    assert_equal transaction.phone.ddd,    '12'
    assert_equal transaction.phone.number, '981433533'

    assert_equal transaction.address.class,         PagarMe::Address
    assert_equal transaction.address.street,        'Av. Brigadeiro Faria Lima'
    assert_equal transaction.address.neighborhood,  'Itaim bibi'
    assert_equal transaction.address.zipcode,       '01452000'
    assert_equal transaction.address.street_number, '2941'
  end

  def assert_transaction_refused_by_acquirer(transaction)
    assert       transaction.id
    assert       transaction.date_created
    assert       transaction.card.id
    assert_equal transaction.refuse_reason,     'acquirer'
    assert_equal transaction.amount,            1000
    assert_equal transaction.installments.to_i, 1
    assert_equal transaction.card_holder_name,  'Jose da Silva'
    assert_equal transaction.payment_method,    'credit_card'
    assert_equal transaction.status,            'refused'
    assert_equal transaction.card_brand,        'visa'
    assert_equal transaction.card.first_digits, '490172'
    assert_equal transaction.card.last_digits,  '4448'
  end

  def assert_transaction_with_bolelo_on_waiting_payment(transaction)
    assert       transaction.date_created
    assert       transaction.boleto_barcode
    assert       transaction.boleto_expiration_date
    assert       transaction.boleto_url
    assert_nil   transaction.card
    assert_nil   transaction.card_holder_name
    assert_equal transaction.payment_method, 'boleto'
    assert_equal transaction.status,         'waiting_payment'
    assert_equal transaction.amount.to_s,    '1000'
  end

  def assert_split_rules(split_rules)
    assert_equal split_rules.size, 4
    rules = split_rules.sort_by &:percentage

    assert_equal rules[0].recipient_id, 're_cikztxdng001ngw6e3p48w5cy'
    assert_equal rules[1].recipient_id, 're_cikztx4wa0026mt6dguqrrqkd'
    assert_equal rules[2].recipient_id, 're_cikztx415001mgw6emvst5syl'
    assert_equal rules[3].recipient_id, 're_cikzr6xs1000amt6d0hgo7n4k'

    assert_equal rules[0].percentage, 10
    assert_equal rules[1].percentage, 20
    assert_equal rules[2].percentage, 30
    assert_equal rules[3].percentage, 40
  end

  def assert_plan_created(plan)
    assert       plan.id
    assert_equal plan.name,       'Plano gold'
    assert_equal plan.trial_days, 5
    assert_equal plan.days,       30
    assert_equal plan.amount,     3000
  end

  def assert_subscription_created(subscription, plan)
    assert       subscription.id
    assert_equal subscription.status, 'trialing'
    assert_equal subscription.plan.id, plan.id
  end

  def assert_transaction_errors(params = {})
    PagarMe::Transaction.create transaction_with_card_params(params)
  rescue PagarMe::ValidationError
    assert_no_match /\s*\,\s*\Z/, $!.message
  end

  def assert_has_error_param(exception, parameter_name)
    assert exception.errors.any?{ |error| error.parameter_name == parameter_name }
  end

  def assert_transfer(transfer)
    assert transfer.id
    assert transfer.fee
    assert_equal transfer.class, PagarMe::Transfer
    assert %w(doc credito_em_conta ted).include?(transfer.type)
  end

  def assert_empty_balance(balance)
    assert_equal balance.available.amount,     0
    assert_equal balance.waiting_funds.amount, 0
    assert_equal balance.transferred.amount,   0
  end

  def assert_available_balance(balance)
    assert(balance.available.amount > 0)
    assert_equal balance.waiting_funds.amount, 0
    assert_equal balance.transferred.amount,   0
  end

  def assert_transfered_balance(balance)
    assert(balance.transferred.amount > 0)
    assert_equal balance.available.amount,     0
    assert_equal balance.waiting_funds.amount, 0
  end

  def assert_increased_available_amount(previous_balance, balance)
    assert(previous_balance.available.amount < balance.available.amount)
    assert_equal previous_balance.waiting_funds.amount, balance.waiting_funds.amount
    assert_equal previous_balance.transferred.amount,   balance.transferred.amount
  end
end
