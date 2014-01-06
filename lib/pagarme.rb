require 'digest/sha1'
require 'pagarme/pagarme_object'
require 'pagarme/util'
require 'pagarme/model'
require 'pagarme/transaction_common'
require 'pagarme/customer'
require 'pagarme/phone'
require 'pagarme/address'
require 'pagarme/subscription'
require 'pagarme/transaction'
require 'pagarme/plan'
require 'pagarme/request'
require 'pagarme/errors'

module PagarMe
  @@api_key = nil
  @@api_endpoint = 'https://api.pagar.me'
  @@api_version = '1'
  @@live = true
  @@api_card_encryption_public_key = File.join(File.dirname(__FILE__), '..', 'certs/public_key.pem')

  def self.api_key=(api_key)
    @@api_key = api_key
  end

  def self.api_key
    @@api_key
  end

  def self.api_card_encryption_public_key
    @@api_card_encryption_public_key
  end

  def self.full_api_url(relative_path)
   "#{@@api_endpoint}/#{@@api_version}#{relative_path}"
  end

  def self.validate_fingerprint(id, fingerprint)
		Digest::SHA1.hexdigest(id.to_s + "#" + @@api_key) == fingerprint	
  end
end
