# Introdução

Essa SDK foi construída com o intuito de torná-la flexível, de forma que todos possam utilizar todas as features, de todas as versões de API.

Você pode acessar a documentação oficial do Pagar.me acessando esse [link](https://docs.pagar.me).

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
- [Postbacks](#postbacks)
  - [Retornando postbacks](#retornando-postbacks)
  - [Validando uma requisição de postback](#validando-uma-requisição-de-postback)
- [Saldo do recebedor principal](#saldo-do-recebedor-principal)
- [Operações de saldo](#operações-de-saldo)
  - [Histórico das operações](#histórico-das-operações)
- [Recebível](#recebível)
  - [Retornando recebíveis](#retornando-recebíveis)
  - [Retornando um recebível](#retornando-um-recebível)
- [Transferências](#transferências)
  - [Criando uma transferência](#criando-uma-transferência)
  - [Retornando transferências](#retornando-transferências)
  - [Retornando uma transferência](#retornando-uma-transferência)
- [Antecipações](#antecipações)
  - [Criando uma antecipação](#criando-uma-antecipação)
  - [Obtendo os limites de antecipação](#obtendo-os-limites-de-antecipação)
  - [Confirmando uma antecipação building](#confirmando-uma-antecipação-building)
  - [Cancelando uma antecipação pending](#cancelando-uma-antecipação-pending)
  - [Deletando uma antecipação building](#deletando-uma-antecipação-building)
  - [Retornando antecipações](#retornando-antecipações)
- [Contas bancárias](#contas-bancárias)
  - [Criando uma conta bancária](#criando-uma-conta-bancária)
  - [Retornando uma conta bancária](#retornando-uma-conta-bancária)
  - [Retornando contas bancárias](#retornando-contas-bancárias)
- [Recebedores](#recebedores)
  - [Criando um recebedor](#criando-um-recebedor)
  - [Retornando recebedores](#retornando-recebedores)
  - [Retornando um recebedor](#retornando-um-recebedor)
  - [Atualizando um recebedor](#atualizando-um-recebedor)
  - [Saldo de um recebedor](#saldo-de-um-recebedor)
  - [Operações de saldo de um recebedor](#operações-de-saldo-de-um-recebedor)
- [Clientes](#clientes)
  - [Criando um cliente](#criando-um-cliente)
  - [Retornando clientes](#retornando-clientes)
  - [Retornando um cliente](#retornando-um-cliente)

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
PagarMe.encryption_key = 'SUA_ENCRYPTION_KEY' # Caso necessário
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
transaction = PagarMe::Transaction.find_by_id("ID_TRANSAÇÃO")
transaction.capture({:amount => 3100})
```

### Estornando uma transação

```ruby
transaction = PagarMe::Transaction.find_by_id("ID_TRANSAÇÃO")
transaction.refund
```

Esta funcionalidade também funciona com estornos parciais, ou estornos com split. Por exemplo:

#### Estornando uma transação parcialmente

```ruby
transaction = PagarMe::Transaction.find_by_id("ID_TRANSAÇÃO")
transaction.refund(amount: partial_amount)
```

#### Estornando uma transação com split

```ruby
transaction = PagarMe::Transaction.find_by_id("ID_TRANSAÇÃO")

transaction.refund({
  async: false,
  amount: 71000,
  split_rules:[
    {
      "id": "ID_SPLIT_RULE",
      "amount": "60000",
      "recipient_id": "ID_REDEBEDOR"
    },
    {
      "id": "ID_SPLIT_RULE",
      "amount": "11000",
      "recipient_id": "ID_REDEBEDOR",
      "charge_processing_fee": "true"
     }
  ]
})
```

### Retornando Transações

```ruby
page = 1
count = 10

transactions = PagarMe::Transaction.all(page, count)
```

### Retornando uma transação 

```ruby
transaction = PagarMe::Transaction.find_by_id("ID_TRANSAÇÃO")
```

### Retornando recebíveis de uma transação

```ruby
payables = PagarMe::Transaction.find('ID_TRANSAÇÃO').payables
```

### Retornando o histórico de operações de uma transação

```ruby
transaction = PagarMe::Transaction.find_by_id("ID_TRANSAÇÃO")

transaction.operations
```

### Notificando cliente sobre boleto a ser pago

```ruby
transaction = PagarMe::Transaction.find_by_id("ID_TRANSAÇÃO")

transaction.collect_payment
```

### Retornando eventos de uma transação 

```ruby
transaction = PagarMe::Transaction.find_by_id("ID_TRANSAÇÃO")

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
transaction = PagarMe::Transaction.find_by_id("ID_TRANSAÇÃO")

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
page = 1
count = 10
transactions = PagarMe::Card.all(page, count)
```

#### Retornando um cartão

```ruby
card = PagarMe::Card.find_by_id("ID_CARTÃO")
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
page = 1
count = 10
plans = PagarMe::Plan.all(page, count)
```

### Retornando um plano

```ruby
plan = PagarMe::Plan.find_by_id("ID_PLANO")
```

### Atualizando um plano

```ruby
plan = PagarMe::Plan.find_by_id("ID_PLANO")

plan.name = "The Pro Plan - Susan"
plan.trial_days = 7

plan.save
```

## Assinaturas

### Criando assinaturas

```ruby
plan = PagarMe::Plan.find_by_id("ID_PLANO")

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
plan = PagarMe::Plan.find_by_id("ID_PLANO")

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
        recipient_id: "ID_RECEBEDOR",
        percentage: 10,
        liable: true,
        charge_processing_fee: true
      } ,
      {
        recipient_id: "ID_RECEBEDOR",
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
subscription = PagarMe::Subscription.find_by_id("ID_ASSINATURA")
```


### Retornando assinaturas

```ruby
page = 1
count = 10
subscriptions = PagarMe::Subscription.all(page, count)
```


### Atualizando uma assinatura

```ruby
subscription = PagarMe::Subscription.find_by_id(ID_ASSINATURA)

subscription.payment_method = 'credit_card'
subscription.card_id = 'ID_CARTÃO'
subscription.plan_id = 'ID_PLANO'

subscription.save
```

### Cancelando uma assinatura

```ruby
subscription = PagarMe::Subscription.find_by_id("ID_ASSINATURA")

subscription.cancel
```

### Transações de assinatura

```ruby
subscription = PagarMe::Subscription.find_by_id("ID_ASSINATURA");

subscription.transactions
```

### Pulando cobranças

```ruby
subscription = PagarMe::Subscription.find_by_id(ID_ASSINATURA)

subscription.settle_charge
```

## Postbacks

Ao criar uma transação ou uma assinatura você tem a opção de passar o parâmetro postback_url na requisição. Essa é uma URL do seu sistema que irá então receber notificações a cada alteração de status dessas transações/assinaturas.

Para obter informações sobre postbacks, 3 informações serão necessárias, sendo elas: `model`, `model_id` e `postback_id`.

`model`: Se refere ao objeto que gerou aquele POSTback. Pode ser preenchido com o valor `transaction` ou `subscription`.

`model_id`: Se refere ao ID do objeto que gerou ao POSTback, ou seja, é o ID da transação ou assinatura que você quer acessar os POSTbacks.

`postback_id`: Se refere à notificação específica. Para cada mudança de status de uma assinatura ou transação, é gerado um POSTback. Cada POSTback pode ter várias tentativas de entregas, que podem ser identificadas pelo campo `deliveries`, e o ID dessas tentativas possui o prefixo `pd_`. O campo que deve ser enviado neste parâmetro é o ID do POSTback, que deve ser identificado pelo prefixo `po_`. 

### Retornando postbacks

`Transações`
```ruby
transactions = PagarMe::Transactions.find_by_id("ID_TRANSAÇÃO")
transactions.postbacks
```

`Assinaturas`
```ruby
subscription = PagarMe::Subscription.find_by_id("ID_ASSINATURA")
subscription.postbacks
```

### Validando uma requisição de postback

```ruby
if PagarMe::Postback.valid_request_signature?(postback_body, '1213e67a3b34c2848f8317d29bcb8cbc9e0979b8')
    puts "Valid Signature"
end
```

## Saldo do recebedor principal

Para saber o saldo de sua conta, você pode utilizar esse código:

```ruby
puts PagarMe::Balance.balance 
```

Observação: o código acima serve somente de exemplo para que o processo de validação funcione. Recomendamos que utilize ferramentas fornecidas por bibliotecas ou frameworks para recuperar estas informações de maneira mais adequada.

## Operações de saldo

Com este objeto você pode acompanhar todas as movimentações financeiras ocorridas em sua conta Pagar.me.

### Histórico das operações

```ruby
puts PagarMe::BalanceOperation.balance_operations
```

## Recebível

Objeto contendo os dados de um recebível. O recebível (payable) é gerado automaticamente após uma transação ser paga. Para cada parcela de uma transação é gerado um recebível, que também pode ser dividido por recebedor (no caso de um split ter sido feito).

### Retornando recebíveis

```ruby
page = 1
count = 10

puts PagarMe::Payable.all(page, count)
```

### Retornando um recebível

```ruby
puts PagarMe::Payable.find_by_id(ID_RECEBÍVEL)
```

## Transferências
Transferências representam os saques de sua conta.

### Criando uma transferência

```ruby
transferencia = PagarMe::Transfer.create({
	:amount => 13000,
  :recipient_id => "ID_REDEBEDOR"
})
```

### Retornando transferências

```ruby
page = 1
count = 10

transferencias = PagarMe::Transfer.all(page, count)
```

### Retornando uma transferência

```ruby
transferencia = PagarMe::Transfer.find_by_id("ID_TRANSFERÊNCIA")
```

## Antecipações

Para entender o que são as antecipações, você deve acessar esse [link](https://docs.pagar.me/docs/overview-antecipacao).

### Criando uma antecipação

```ruby
recipient = PagarMe::Recipient.find_by_id("ID_REDEBEDOR")
bulk_anticipation = recipient.bulk_anticipate(
	:requested_amount => 1000,
	:payment_date => Date.today + 7,
	:timeframe => :end
)
```

### Obtendo os limites de antecipação

```ruby
recipient_id = "ID_REDEBEDOR"
payment_date = Date.today + 7
timeframe = :end
PagarMe::Recipient.find_by_id(recipient_id).bulk_anticipations_limits(
  payment_date: payment_date, 
  time_frame: timeframe
)
```

### Confirmando uma antecipação building

```ruby
recipient = PagarMe::Recipient.find_by_id("ID_REDEBEDOR")
bulk_anticipation_id = "ID_ANTECIPAÇÃO"
bulk_anticipation = recipient.bulk_anticipations({:id => bulk_anticipation_id})[0]
bulk_anticipation.confirm
```

### Cancelando uma antecipação pending

```ruby
recipient = PagarMe::Recipient.find_by_id("ID_REDEBEDOR")
bulk_anticipation_id = "ID_ANTECIPAÇÃO"
bulk_anticipation = recipient.bulk_anticipations({:id => bulk_anticipation_id})[0]
bulk_anticipation.cancel
```

### Deletando uma antecipação building

```ruby
recipient = PagarMe::Recipient.find_by_id("ID_REDEBEDOR")
bulk_anticipation = recipient.bulk_anticipations({:id => "ID_ANTECIPAÇÃO"})[0]
p bulk_anticipation
bulk_anticipation.delete
```

### Retornando antecipações

```ruby
recipient_id = "ID_REDEBEDOR"
recipient = PagarMe::Recipient.find_by_id(recipient_id)
bulk_anticipations = recipient.bulk_anticipations
```

## Contas bancárias

Contas bancárias identificam para onde será enviado o dinheiro de futuros pagamentos.

### Criando uma conta bancária

```ruby
bank_account = PagarMe::BankAccount.new({
    :bank_code => '237',
    :agencia => '1935',
    :agencia_dv => '9',
    :conta => '23398',
    :conta_dv => '9',
    :legal_name => 'API BANK ACCOUNT',
    :document_number => '26268738888'
})

bank_account.create
```

### Retornando uma conta bancária

```ruby
bank_account = PagarMe::BankAccount.find_by_id("ID_BANK_ACCOUNT")
```

### Retornando contas bancárias

```ruby
bank_accounts = PagarMe::BankAccount.find_by({ bank_code: '341' })
```

## Recebedores

Para dividir uma transação entre várias entidades, é necessário ter um recebedor para cada uma dessas entidades. Recebedores contém informações da conta bancária para onde o dinheiro será enviado, e possuem outras informações para saber quanto pode ser antecipado por ele, ou quando o dinheiro de sua conta será sacado automaticamente.

### Criando um recebedor

```ruby
recipient = PagarMe::Recipient.new({
    :anticipatable_volume_percentage => 85, 
    :automatic_anticipation_enabled => true, 
    :bank_account_id => "17490076", 
    :transfer_day => "5", 
    :transfer_enabled => true, 
    :transfer_interval => "weekly"
}).create
```

### Retornando recebedores

```ruby
page = 1
count = 10

recipients = PagarMe::Recipient.all(page, count)
# ou
recipients = PagarMe::Recipient.all()
```

### Retornando um recebedor

```ruby
recipient = PagarMe::Recipient.find_by_id(ID_REDEBEDOR)
```

### Atualizando um recebedor

```ruby
recipient = PagarMe::Recipient.find_by_id(ID_REDEBEDOR)
recipient.transfer_interval = :daily
recipient.transfer_day = 0
recipient.anticipatable_volume_percentage = 100
recipient.bank_account_id = '17490076'
recipient.save
```

### Saldo de um recebedor

```ruby
recipient = PagarMe::Recipient.find_by_id(ID_REDEBEDOR)
p recipient.balance
```

### Operações de saldo de um recebedor

```ruby
recipient = PagarMe::Recipient.find_by_id(ID_REDEBEDOR)
p recipient.balance_operations
```

## Clientes

Clientes representam os usuários de sua loja, ou negócio. Este objeto contém informações sobre eles, como nome, e-mail e telefone, além de outros campos.

### Criando um cliente

```ruby
customer = PagarMe::Customer.create(
  name: 'Tommy Oliver',
  email: 'mopheus@nabucodonozor.com',
  type: 'individual',
  external_id: "222",
  country: 'br',
  birthday: "1965-01-01",
  documents: [
    {type: "cpf", number: "86870624194"}
  ],
  phone_numbers: ["+5511999998888", "+5511888889999"]
)
```

### Retornando clientes

```ruby
page = 1
count = 10

customer = PagarMe::Customer.all(page, count)
```

### Retornando um cliente

```ruby
customer = PagarMe::Customer.find_by_id(ID_CUSTOMER)
```

# Support
Caso você tenha algum problema ou sugestão crie uma issue [aqui](https://github.com/pagarme/pagarme-ruby/issues).

# License

Clique aqui [here](LICENSE).