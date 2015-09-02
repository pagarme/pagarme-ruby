# encoding: utf-8
require File.join(File.dirname(__FILE__), '..', 'pagarme')

module PagarMe
  class Util
    class << self
      def pagarme_classes
        {
          'transaction' => Transaction,
          'plan' => Plan,
          'customer' => Customer,
          'subscription' => Subscription,
          'address' => Address,
          'phone' => Phone
        }
      end

      def convert_to_pagarme_object(response)
        case response
        when Array
          response.map { |i| convert_to_pagarme_object(i) }
        when Hash
          pagarme_classes.fetch(
            response['object'], PagarMeObject
          ).build(response)
        else
          response
        end
      end

      def url_encode(key)
        URI.encode_www_form_component(key.to_s)
      end
    end
  end
end
