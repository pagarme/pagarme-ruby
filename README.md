# pagarme-ruby
[![Build Status](https://travis-ci.org/pagarme/pagarme-ruby.png)](https://travis-ci.org/pagarme/pagarme-ruby)

Pagar.me Ruby library

## Documentation

* [Documentation](https://pagar.me/docs)
* [Full API Guide](https://docs.pagar.me/api)

## Getting Started

### Install

```shell
gem install pagarme
```
or add the following line to Gemfile:

```ruby
gem 'pagarme'
```
and run `bundle install` from your shell.

### Configure your API key

You can set your API key in Ruby:

```ruby
PagarMe.api_key = 'YOUR_API_KEY_HERE'
```

or set the environment variable _PAGARME\_API\_KEY_ (**recommended**)

### Using Pagar.me Checkout

See our [demo checkout](https://pagar.me/checkout).

More about how to use it [here](https://docs.pagar.me/checkout).

### Transactions

#### Creating a Credit Card Transaction

To create a credit card transaction, you need a [card\_hash](https://docs.pagar.me/capturing-card-data).

```ruby
  PagarMe::Transaction.new(
    amount:    1000,      # in cents
    card_hash: card_hash  # how to get a card hash: docs.pagar.me/capturing-card-data
  ).charge
```

More about [Creating a Credit Card Transaction](https://docs.pagar.me/transactions/#realizando-uma-transacao-de-cartao-de-credito).

#### Creating a Boleto Transaction

```ruby
  transaction = PagarMe::Transaction.new(
    amount:         1000,    # in cents
    payment_method: 'boleto'
  )
  transaction.charge

  transaction.boleto_url     # => boleto's URL
  transaction.boleto_barcode # => boleto's barcode
```

More about [Creating a Boleto Transaction](https://docs.pagar.me/transactions/#realizando-uma-transacao-de-boleto-bancario).

### Plans & Subscriptions

You can use recurring charges, learn more [here](https://docs.pagar.me/plans-subscriptions).

It's important to understand the charges flow, learn more [here](https://docs.pagar.me/plans-subscriptions/#fluxo-de-cobranca)

#### Creating a Plan

```ruby
  PagarMe::Plan.new(
    amount: 4990,
    days:   30,
    name:   'Gold Plan'
  ).create
```

More about [Creating a Plan](https://docs.pagar.me/plans-subscriptions/#criando-um-plano).

#### Creating a Subscription

```ruby
  PagarMe::Subscription.new(
    plan:      PagarMe::Plan.find_by_id('1234'),
    card_hash: card_hash,
    customer:  { email: 'customer_email@pagar.me' }
  ).create
```

More about [Creating a Subscription](https://docs.pagar.me/plans-subscriptions/#criando-uma-assinatura).

### Undocumented Features

This gem is stable, but in constant development.

This README is just a quick abstract of it's main features.

You can easily browse it's source code to see all [supported resources](https://github.com/pagarme/pagarme-ruby/tree/master/lib/pagarme/resources).

We will document everything while adding support to all resources listed in
[Full API Guide](https://docs.pagar.me/api).

Feel free to help us to add support to features sending pull requests.

Thanks!

### TODO

Add support to:

* [Balance](https://docs.pagar.me/api/#saldo)
* [BalanceOperation](https://docs.pagar.me/api/#operacoes-de-saldo)
* [BulkAnticipation](https://docs.pagar.me/api/#antecipacoes)
* [SplitRule](https://docs.pagar.me/api/#regras-do-split)

Add support to [ElasticSearch Query DSL](https://docs.pagar.me/api/#buscas-avancadas),
so you can search your data optimally.

And document the all the source code

## License

Pagar.me Ruby library is released under the [MIT License](http://www.opensource.org/licenses/MIT).
