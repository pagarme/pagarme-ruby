# encoding: utf-8
require File.join(File.dirname(__FILE__), '..', 'pagarme')

module PagarMe
  class Util
    def self.calculate_installments(params)
      request = PagarMe::Request.new('/transactions/calculate_installments_amount', 'GET')
      request.parameters.merge!(params)
      response = request.run
      response
    end

    def self.pagarme_classes
      return {
        'transaction' => Transaction,
        'plan' => Plan,
        'customer' => Customer,
        'subscription' => Subscription,
        'address' => Address,
        'phone' => Phone,
      }
    end

    def self.convert_to_pagarme_object(response)
      case response
      when Array
        response.map{ |i| convert_to_pagarme_object(i)}
      when Hash
        self.pagarme_classes.fetch(response['object'], PagarMeObject).build(response)
      else
        response
      end
    end

    def self.url_encode(key)
      URI.escape(key.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end


    def self.normalize_params(parameters, parent = nil)
      ret = []
      parameters.each do |k, v|
        current_key = parent ? "#{parent}[#{url_encode(k)}]" : url_encode(k)
        case v
        when Hash
          ret += normalize_params(v, current_key)
        when Array
          ret += normalize_array_params(v, current_key)
        else
          ret << [current_key, v]
        end
      end
      ret
    end

    def self.normalize_array_params(value, current_key)
      ret = []
      value.each do |element|
        case element
        when Hash
          ret += normalize_params(element, current_key)
        when Array
          ret += normalize_array_params(element, current_key)
        else
          ret << ["#{current_key}[]", element]
        end
      end
      ret
    end
  end
end

class Hash
  def to_params
    self.map{ |key, value| "#{key}=#{value}" }.join('&')
  end
end

class Array
  def to_params
    self.map{ |key, value| "#{key}=#{value}" }.join('&')
  end
end


