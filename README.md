# Introdução

This SDK was built in order to make it flexible, so that everyone can use all the features, from all API versions.

You can access the official Pagar.me documentation by accessing this [link](https://docs.pagar.me).

Besides, you can also access the reference documentation for all SDKs by accessing this [link](https://docs.pagar.me/reference).


## Index

- [Instalação](#instalação)
- [Configuração](#configuração)
- [Transações](#transações)
- [Criando uma transação](#criando-uma-transação)
- [Capturando uma transação](#capturando-uma-transação)
- [Estornando uma transação](#estornando-uma-transação)
  - [Estornando uma transação parcialmente](#estornando-uma-transação-parcialmente)
  - [Estornando uma transação com split](#estornando-uma-transação-com-split)
- [Retornando transações](#retornando-transações)
- [Retornando uma transação](#retornando-uma-transação)
- [Retornando recebíveis de uma transação](#retornando-recebíveis-de-uma-transação)
- [Retornando o histórico de operações de uma transação](#retornando-o-histórico-de-operações-de-uma-transação)
- [Notificando cliente sobre boleto a ser pago](#notificando-cliente-sobre-boleto-a-ser-pago)
- [Retornando eventos de uma transação](#retornando-eventos-de-uma-transação)
- [Calculando Pagamentos Parcelados](#calculando-pagamentos-parcelados)
- [Testando pagamento de boletos](#testando-pagamento-de-boletos)
- [Cartões](#cartões)
  - [Criando cartões](#criando-cartões)
  - [Retornando cartões](#retornando-cartões)
  - [Retornando um cartão](#retornando-um-cartão)
- [Planos](#planos)
  - [Criando planos](#criando-planos)
  - [Retornando planos](#retornando-planos)
  - [Retornando um plano](#retornando-um-plano)
  - [Atualizando um plano](#atualizando-um-plano)
- [Assinaturas](#assinaturas)
  - [Criando assinaturas](#criando-assinaturas)
  - [Split com assinatura](#split-com-assinatura)
  - [Retornando uma assinatura](#retornando-uma-assinatura)
  - [Retornando assinaturas](#retornando-assinaturas)
  - [Atualizando uma assinatura](#atualizando-uma-assinatura)
  - [Cancelando uma assinatura](#cancelando-uma-assinatura)
  - [Transações de assinatura](#transações-de-assinatura)
  - [Pulando cobranças](#pulando-cobranças)
 

## Instalação

Instale a biblioteca utilizando o comando:

```shell
gem install pagarme
```

ou adicione a linha ao Gemfile:

```ruby
gem 'pagarme'
```

e execute o comando `bundle install` no seu terminal.

## Configuração

Para incluir a biblioteca em seu projeto, basta fazer o seguinte:

```ruby
require 'pagarme'

PagarMe.api_key        = 'SUA_CHAVE_DE_API'
```

## Transações

Nesta seção será explicado como utilizar transações no Pagar.me com essa biblioteca.

### Criando uma transação

```ruby
  PagarMe::Transaction.new(
    amount: 100,                                               
    payment_method: "credit_card", 
    card_number: "4111111111111111",
    card_holder_name: "Morpheus Fishburne", 
    card_expiration_date: "1123", 
    card_cvv: "123",
    postback_url: "http://requestb.in/pkt7pgpk", 
    customer: {
      external_id: "#3311",
      name: "Morpheus Fishburne",
      type: "individual",
      country: "br",
      email: "mopheus@nabucodonozor.com",
      documents: [
        {
          type: "cpf",
          number: "30621143049"

        }
      ],
      phone_numbers: ["+5511999998888", "+5511888889999"],
      birthday: "1965-01-01"
    },
    billing: {
      name: "Trinity Moss",
      address: {
        country: "br",
        state: "sp",
        city: "Cotia",
        neighborhood: "Rio Cotia",
        street: "Rua Matrix",
        street_number: "9999",
        zipcode: "06714360"
      }
    },
    shipping: {
      name: "Neo Reeves",
      fee: 1000,
      delivery_date: "2000-12-21",
      expedited: true,
      address: {
        country: "br",
        state: "sp",
        city: "Cotia",
        neighborhood: "Rio Cotia",
        street: "Rua Matrix",
        street_number: "9999",
        zipcode: "06714360"
      }
    },
    items: [
      {
        id: "r123",
        title: "Red pill",
        unit_price: 10000,
        quantity: 1,
        tangible: true
      },
      {
        id: "b123",
        title: "Blue pill",
        unit_price: 10000,
        quantity: 1,
        tangible: true
      }
    ]
  ).charge
```

### Capturando uma transação

```ruby
transaction = PagarMe::Transaction.find_by_id("transaction_id")
transaction.capture({:amount => 3100})
```

### Estornando uma transação

```ruby
transaction = PagarMe::Transaction.find_by_id("transaction_id")
transaction.refund
```

Esta funcionalidade também funciona com estornos parciais, ou estornos com split. Por exemplo:

#### Estornando uma transação parcialmente

```ruby
transaction = PagarMe::Transaction.find_by_id("transaction_id")
transaction.refund(amount: partial_amount)
```

#### Estornando uma transação com split

```ruby
transaction = PagarMe::Transaction.find_by_id("transaction_id")

transaction.refund({
  async: false,
  amount: 71000,
  split_rules:[
    {
      "id": "sr_cj41w9m4d01ta316d02edaqav",
      "amount": "60000",
      "recipient_id": "re_cj2wd5ul500d4946do7qtjrvk"
    },
    {
      "id": "sr_cj41w9m4e01tb316dl2f2veyz",
      "amount": "11000",
      "recipient_id": "re_cj2wd5u2600fecw6eytgcbkd0",
      "charge_processing_fee": "true"
     }
  ]
})
```

### Retornando Transações

```ruby
  transactions = PagarMe::Transaction.all(3, 3)
```

### Retornando uma transação 

```ruby
  transaction = PagarMe::Transaction.find_by_id("transaction_id")
```

### Retornando recebíveis de uma transação

```ruby
  payables = PagarMe::Transaction.find('transaction_id').payables
```

### Retornando o histórico de operações de uma transação

```ruby
transaction = PagarMe::Transaction.find_by_id("transaction_id")

transaction.operations
```

### Notificando cliente sobre boleto a ser pago

```ruby
transaction = PagarMe::Transaction.find_by_id("transaction_id")

transaction.collect_payment
```

### Retornando eventos de uma transação 

```ruby
transaction = PagarMe::Transaction.find_by_id("transaction_id")

transaction.events
```

### Calculando pagamentos parcelados

Essa rota não é obrigatória para uso. É apenas uma forma de calcular pagamentos parcelados com o Pagar.me.

Para fins de explicação, utilizaremos os seguintes valores:

`amount`: 1000, `free_installments`: 4, `max_installments`: 12, `interest_rate`: 3

O parâmetro `free_installments` decide a quantidade de parcelas sem juros. Ou seja, se ele for preenchido com o valor `4`, as quatro primeiras parcelas não terão alteração em seu valor original.

Nessa rota, é calculado juros simples, efetuando o seguinte calculo:

valorTotal = valorDaTransacao * ( 1 + ( taxaDeJuros * numeroDeParcelas ) / 100 )

Então, utilizando os valores acima, na quinta parcela, a conta ficaria dessa maneira:

valorTotal = 1000 * (1 + (3 * 5) / 100)

Então, o valor a ser pago na quinta parcela seria de 15% da compra, totalizando 1150.

Você pode usar o código abaixo caso queira utilizar essa rota:

```ruby
installments_result = PagarMe::Transaction.calculate_installments({
    amount: 10000,
    interest_rate: 13
})
```

### Testando pagamento de boletos

```ruby
  transaction = PagarMe::Transaction.find_by_id("transaction_id")

  transaction.status = 'paid'

  transaction.save
```


## Cartões

Sempre que você faz uma requisição através da nossa API, nós guardamos as informações do portador do cartão, para que, futuramente, você possa utilizá-las em novas cobranças, ou até mesmo implementar features como one-click-buy.


### Criando Cartões

```ruby
card = PagarMe::Card.new({
	:card_number => '4018720572598048',
  :card_holder_name => 'Aardvark Silva',
	:card_expiration_month => '11',
	:card_expiration_year => '22',
	:card_cvv => '123'
})

card.create
```

#### Retornando cartões

```ruby
transactions = PagarMe::Card.all
```

#### Retornando um cartão

```ruby
card = PagarMe::Card.find_by_id("card_cj428xxsx01dt3f6dvre6belx")
```

## Planos

Representa uma configuração de recorrência a qual um cliente consegue assinar.
É a entidade que define o preço, nome e periodicidade da recorrência

### Criando planos

```ruby
plan = PagarMe::Plan.new({
    :name => "The Pro Plan - Platinum  - Best Ever",
    :days => 30,
    :amount => 15000
})

plan.create
```

### Retornando planos

```ruby
plans = PagarMe::Plan.all(1, 10)
```

### Retornando um plano

```ruby
plan = PagarMe::Plan.find_by_id("164526")
```

### Atualizando um plano

```ruby
plan = PagarMe::Plan.find_by_id("163871")

plan.name = "The Pro Plan - Susan"
plan.trial_days = 7

plan.save
```

## Assinaturas

### Criando assinaturas

```ruby
plan = PagarMe::Plan.find_by_id("12783")

subscription = PagarMe::Subscription.new({
    :payment_method => 'credit_card',
    :card_hash => "CARD_HASH_GERADO",
    :postback_url => "http://test.com/postback",
    :customer => {
        :name => "John Appleseed",
        :document_number => "92545278157",
        :email => "jappleseed@apple.com",
        :address => {
            :street => "Rua Dr. Geraldo Campos Moreira",
            :neighborhood => "Cidade Monções",
            :zipcode => "04571020",
            :street_number => "240"
        },
        :phone => {
            :ddd => "11"
            :number => "15510101"
        }
    }
})
subscription.plan = plan

subscription.create
```

### Split com assinatura

```ruby
plan = PagarMe::Plan.find_by_id("12783")

subscription = PagarMe::Subscription.new({
    :payment_method => 'credit_card',
    :card_number => "4901720080344448",
    :card_holder_name => "Jose da Silva",
    :card_expiration_month => "10",
    :card_expiration_year => "15",
    :card_cvv => "314",
    :postback_url => "http://test.com/postback",
    :customer => {
        :name => "John Appleseed",
        :document_number => "92545278157",
        :email => "jappleseed@apple.com",
        :address => {
            :street => "Rua Dr. Geraldo Campos Moreira",
            :neighborhood => "Cidade Monções",
            :zipcode => "04571020",
            :street_number => "240"
        },
        :phone => {
            :ddd => "11"
            :number => "15510101"
        }
    },
    :split_rules: [
        {
          recipient_id: "re_cj2wd5ul500d4946do7qtjrvk",
          percentage: 10,
          liable: true,
          charge_processing_fee: true
        } ,
        {
          recipient_id: "re_cj2wd5u2600fecw6eytgcbkd0",
          percentage: 90,
          liable: true,
          charge_processing_fee: true
        } 
    ])
subscription.plan = plan

subscription.create
```


### Retornando uma assinatura

```ruby
subscription = PagarMe::Subscription.find_by_id("205881")
```


### Retornando assinaturas

```ruby
subscriptions = PagarMe::Subscription.all()
```


### Atualizando uma assinatura

```ruby
subscription = PagarMe::Subscription.find_by_id(subscription_id)

subscription.payment_method = 'credit_card'
subscription.card_id = 'card_cj41mpuhc01bb3f6d8exeo072'
subscription.plan_id = '166234'

subscription.save
```

### Cancelando uma assinatura

```ruby
subscription = PagarMe::Subscription.find_by_id("205880")

subscription.cancel
]);
```

### Transações de assinatura
```ruby
subscription = PagarMe::Subscription.find_by_id("205881");

subscription.transactions
```

### Pulando cobranças

```ruby
subscription_id = "205881"
subscription = PagarMe::Subscription.find_by_id(subscription_id)

subscription.settle_charge
```

# Support
If you have any problem or suggestion please open an issue [here](https://github.com/pagarme/pagarme-ruby/issues).

# License

Check [here](LICENSE).

```ruby

```