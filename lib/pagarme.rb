require 'set'
require 'time'
require 'digest/sha1'
require 'openssl'

require_relative 'pagarme/version'
require_relative 'pagarme/core_ext'
require_relative 'pagarme/object'
require_relative 'pagarme/model'
require_relative 'pagarme/nested_model'
require_relative 'pagarme/transaction_common'
require_relative 'pagarme/request'
require_relative 'pagarme/errors'

Dir[File.expand_path('../pagarme/resources/*.rb', __FILE__)].map do |path|
  require path
end

module PagarMe
  class << self
    attr_accessor :api_endpoint, :open_timeout, :timeout, :api_key, :encryption_key
  end

  self.api_endpoint   = 'https://api.pagar.me/1'
  self.open_timeout   = 30
  self.timeout        = 90
  self.api_key        = ENV['PAGARME_API_KEY']
  self.encryption_key = ENV['PAGARME_ENCRYPTION_KEY']

  # TODO: Remove deprecated PagarMe.validate_fingerprint
  def self.validate_fingerprint(*args)
    raise '[Deprecation Error] PagarMe.validate_fingerprint is deprecated, use PagarMe::Postback.valid_request_signature? instead'
  end

  def self.production?
    ENV['RACK_ENV']  == 'production' ||
    ENV['RAILS_ENV'] == 'production' ||
    ENV['PRODUCTION'] ||
    ENV['production']
  end
end
