# pagarme-ruby
[![Build Status](https://travis-ci.org/pagarme/pagarme-ruby.png)](https://travis-ci.org/pagarme/pagarme-ruby)

Pagar.me Ruby library

## Documentation

* [Documentation](https://docs.pagar.me)
* [Full API Guide](https://docs.pagar.me/reference)

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
PagarMe.api_key        = 'YOUR_API_KEY_HERE'
PagarMe.encryption_key = 'YOUR_ENCRYPTION_KEY_HERE' # If needed
```

or set the environment variable _PAGARME\_API\_KEY_ (**recommended**)
and _PAGARME\_ENCRYPTION\_KEY_ (**recommended if needed**)

### Using Pagar.me Checkout

See our [demo checkout](https://pagar.me/checkout).

More about how to use it [here](https://docs.pagar.me/docs/overview-checkout).

### Transactions

#### Creating a Credit Card Transaction

To create a credit card transaction, you need a [card\_hash](https://docs.pagar.me/docs/obtendo-os-dados-do-cartao).

```ruby
  PagarMe::Transaction.new(
    amount:    1000,      # in cents
    card_hash: card_hash  # how to get a card hash: docs.pagar.me/capturing-card-data
  ).charge
```

More about [Creating a Credit Card Transaction](https://docs.pagar.me/docs/realizando-uma-transacao-de-cartao-de-credito).

#### Creating a Customer

```ruby
  customer = PagarMe::Customer.create(
    name: 'Morpheus Fishburne',
    email: 'mopheus@nabucodonozor.com',
    type: 'individual',
    external_id: "#3311",
    country: 'br',
    birthday: "1965-01-01",
    documents: [
      {type: "cpf", number: "86870624194"}
    ],
    phone_numbers: ["+5511999998888", "+5511888889999"]
  )
```

More about [Creating a Customer](https://docs.pagar.me/v2017-08-28/reference#criando-um-cliente).

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

More about [Creating a Boleto Transaction](https://docs.pagar.me/docs/realizando-uma-transacao-de-boleto-bancario).

#### Split Rules

With split rules, received amount could be splitted between more than one recipient.
For example, splitting equally a transaction:

```ruby
  PagarMe::Transaction.new(
    amount:    1000,      # in cents
    card_hash: card_hash, # how to get a card hash: docs.pagar.me/capturing-card-data
    split_rules: [
      { recipient_id: recipient_id_1, percentage: 50 },
      { recipient_id: recipient_id_2, percentage: 50 }
    ]
  ).charge
```

More about [Split Rules](https://docs.pagar.me/reference#retornando-uma-regra-de-divis%C3%A3o-espec%C3%ADfica).

### Plans & Subscriptions

You can use recurring charges, learn more [here](https://docs.pagar.me/docs/overview-recorrencia).

It's important to understand the charges flow, learn more [here](https://docs.pagar.me/docs/fluxo-de-cobranca)

#### Creating a Plan

```ruby
  PagarMe::Plan.new(
    amount: 4990,
    days:   30,
    name:   'Gold Plan'
  ).create
```

More about [Creating a Plan](https://docs.pagar.me/docs/criando-um-plano).

#### Creating a Subscription

```ruby
  PagarMe::Subscription.new(
    plan:      PagarMe::Plan.find_by_id('1234'),
    card_hash: card_hash,
    customer:  { email: 'customer_email@pagar.me' }
  ).create
```

More about [Creating a Subscription](https://docs.pagar.me/docs/criando-uma-assinatura).

### Recipients

#### Creating a Recipient

To create a recipient, so it can receive payments through split rules or transfers:

```ruby
  PagarMe::Recipient.create(
    bank_account: {
      bank_code:       '237',
      agencia:         '1935',
      agencia_dv:      '9',
      conta:           '23398',
      conta_dv:        '9',
      legal_name:      'Fulano da Silva',
      document_number: '00000000000000' # CPF or CNPJ
    },
    transfer_enabled: false
  )
```

More about [Creating a Recipient](https://docs.pagar.me/reference#criando-um-recebedor).

#### Transfer Available Amout to Bank Account Manually

This is only needed if _transfer\_enabled_ is set to false. If set to true,
_transfer\_interval_ and _transfer\_day_ will handle it automatically.

```ruby
  PagarMe::Recipient.find(recipient_id).receive amount
```

### Balance And Balance Operations

#### Checking Balance

```ruby
  balance = PagarMe::Balance.balance
  balance.waiting_funds.amount # money to be received in your account
  balance.available.amount     # in your pagarme account
  balance.transferred.amount   # transferred to your bank account
```

Just that!

More about [Balance](https://docs.pagar.me/docs/overview-gerenciamento-de-saldo)

#### Checking Balance Operations

To access the history of balance operations:

```ruby
  PagarMe::BalanceOperation.balance_operations
```

Paginating:

```ruby
  PagarMe::BalanceOperation.balance_operations 2, 50 # second page, 50 per page
```

More about [Balance Operations](https://docs.pagar.me/docs/composicao-do-saldo)

#### Checking Recipient Balance

```ruby
  balance = PagarMe::Recipient.find(recipient_id).balance
  balance.waiting_funds.amount # money to be received in his account
  balance.available.amount     # in his pagarme account
  balance.transferred.amount   # transferred to his bank account
```

Just that!

More about [Recipient Balance](https://docs.pagar.me/api/#saldo-de-um-recebedor)

#### Checking Recipient Balance Operations

To access the history of balance operations:

```ruby
  PagarMe::Recipient.find(recipient_id).balance_operations
```

Paginating:

```ruby
  PagarMe::Recipient.find(recipient_id).balance_operations 2, 50 # second page, 50 per page
```

More about [Recipient Balance Operations](https://docs.pagar.me/reference#opera%C3%A7%C3%B5es-de-saldo-de-um-recebedor)

### Request Bulk Anticipation

#### Checking limits

```ruby
  PagarMe::Recipient.default.bulk_anticipations_limits
```

More about [Checking Bulk Anticipation Limits](https://docs.pagar.me/reference#obtendo-os-limites-de-antecipa%C3%A7%C3%A3o)

#### Requesting Bulk Anticipation

```ruby
  PagarMe::Recipient.default.bulk_anticipate(
    timeframe:        :start,
    payment_date:     Date.new(2016, 12, 25),
    requested_amount: 10000 # in cents
  )
```

More about [Requesting Bulk Anticipation](https://docs.pagar.me/reference#criando-uma-antecipa%C3%A7%C3%A3o)

#### Getting Bulk Anticipation

```ruby
  PagarMe::BulkAnticipation.all page, count
```

More about [Getting Bulk Anticipation](https://docs.pagar.me/reference#retornando-todas-as-antecipa%C3%A7%C3%B5es)

### Payables

### Getting Payable

```ruby
  PagarMe::Payable.find 'payable_id'
```

More about [Getting Payable](https://docs.pagar.me/reference#retornando-um-receb%C3%ADvel)

#### Querying Payables

```ruby
  PagarMe::Payable.all page, count
```

```ruby
  PagarMe::Payable.find_by status: 'paid'
```

More about [Querying Payables](https://docs.pagar.me/reference#retornando-receb%C3%ADveis)

#### Querying Payables by Transaction

```ruby
  transaction = PagarMe::Transaction.find 'transaction_id'
  transaction.payables
```

More about [Payable Transactions](https://docs.pagar.me/reference#retornando-pagamentos-da-transa%C3%A7%C3%A3o)

### Validating Postback

You need to ensure that all received postback are sent by Pagar.me and not from anyone else,
to do this, is very important to validate it.

You must do it using the raw payload received on post request, and check it signature provided
in HTTP header X-Hub-Signature.

You can check it like this:

```ruby
  PagarMe::Postback.valid_request_signature?(payload, signature)
```

#### Rails Example

If you are using Rails, you should do it your controller like this:

```ruby

    class PostbackController < ApplicationController
      skip_before_action :verify_authenticity_token
      
      def postback
        if valid_postback?
          # Handle your code here
          # postback payload is in params
        else
          render_invalid_postback_response
        end
      end
      
      protected
      def valid_postback?
        raw_post  = request.raw_post
        signature = request.headers['HTTP_X_HUB_SIGNATURE']
        PagarMe::Postback.valid_request_signature?(raw_post, signature)
      end
      
      def render_invalid_postback_response
        render json: {error: 'invalid postback'}, status: 400
      end
    end


```

request.raw_post

### Undocumented Features

This gem is stable, but in constant development.

This README is just a quick abstract of it's main features.

You can easily browse it's source code to see all [supported resources](https://github.com/pagarme/pagarme-ruby/tree/master/lib/pagarme/resources).

We will document everything while adding support to all resources listed in
[Full API Guide](https://docs.pagar.me/reference).

Feel free to help us to add support to features sending pull requests.

Thanks!

### TODO

Add support to [ElasticSearch Query DSL](https://docs.pagar.me/reference#elasticsearch),
so you can search your data optimally.

And document all the source code.

## Support
If you have any problem or suggestion please open an issue [here](https://github.com/pagarme/pagarme-ruby/issues).

## License

Check [here](LICENSE).
