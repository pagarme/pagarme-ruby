## pagarme-ruby

Pagar.me Ruby library

## Documentation

* [API Guide](http://pagar.me/docs)

## Getting started

```ruby
# Configure your api key
PagarMe.api_key = "YOUR_API_KEY_HERE"

# Creating a transaction

transaction = PagarMe::Transaction.new
transaction.card_number = "4901720080344448"
transaction.card_holder_name = "Jose da Silva"
transaction.card_expiration_month = "12"
transaction.card_expiration_year = "15"
transaction.card_cvv = "314"
transaction.amount = 1000

transaction.charge
```

## Code Status

[![Build Status](https://travis-ci.org/pagarme/pagarme-ruby.png)](https://travis-ci.org/pagarme/pagarme-ruby)

## License

Pagar.me Ruby library is released under the [MIT License](http://www.opensource.org/licenses/MIT).
