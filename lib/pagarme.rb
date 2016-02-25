require 'set'
require 'time'
require 'digest/sha1'

require_relative 'pagarme/version'
require_relative 'pagarme/object'
require_relative 'pagarme/model'
require_relative 'pagarme/transaction_common'
require_relative 'pagarme/request'
require_relative 'pagarme/errors'

Dir[File.expand_path('../pagarme/resources/*.rb', __FILE__)].map do |path|
  require path
end

module PagarMe
  class << self
    attr_accessor :api_endpoint, :open_timeout, :timeout, :api_key
  end

  self.api_endpoint = 'https://api.pagar.me/1'
  self.open_timeout = 30
  self.timeout      = 90
  self.api_key      = ENV['PAGARME_API_KEY']

  def self.validate_fingerprint(id, fingerprint)
    Digest::SHA1.hexdigest(id.to_s + "#" + api_key) == fingerprint
  end
end
