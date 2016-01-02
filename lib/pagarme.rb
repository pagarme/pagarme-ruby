require 'digest/sha1'
require_relative 'pagarme/object'
require_relative 'pagarme/util'
require_relative 'pagarme/model'
require_relative 'pagarme/transaction_common'
require_relative 'pagarme/customer'
require_relative 'pagarme/phone'
require_relative 'pagarme/address'
require_relative 'pagarme/subscription'
require_relative 'pagarme/transaction'
require_relative 'pagarme/transfer'
require_relative 'pagarme/card'
require_relative 'pagarme/plan'
require_relative 'pagarme/bank_account'
require_relative 'pagarme/recipient'
require_relative 'pagarme/request'
require_relative 'pagarme/errors'

module PagarMe
  @@api_key = nil
  @@api_endpoint = 'https://api.pagar.me/1'
  @@live = true

  def self.api_endpoint=(api_endpoint)
    @@api_endpoint = api_endpoint
  end

  def self.api_endpoint
    @@api_endpoint
  end

  def self.api_key=(api_key)
    @@api_key = api_key
  end

  def self.api_key
    @@api_key
  end

  def self.full_api_url(relative_path)
    "#{@@api_endpoint}#{relative_path}"
  end

  def self.validate_fingerprint(id, fingerprint)
    Digest::SHA1.hexdigest(id.to_s + "#" + @@api_key) == fingerprint
  end
end
