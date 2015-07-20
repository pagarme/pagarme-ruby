# encoding: utf-8
require 'set'

module PagarMe
	class PagarMeObject
		def initialize(response = {})
			#init @attributes - which are the attributes in the object
			@attributes = {}

			# Values that were changed in the object but weren't saved
			@unsaved_values = Set.new

			# Methods that already existed
			@@existing_methods = Array.new

			#Update object
			update(response)
		end

		def self.build(attributes)
			self.new(attributes)
		end

		def update(attributes)
			attributes.each do |key, value|
				key = key.to_s

				@attributes[key] = Util.convert_to_pagarme_object(value)
				@unsaved_values.delete(key)
			end
		end

		def each(&block)
			@attributes.each(&block)
		end

		def []=(key,value)
			@attributes[key] = value
		end

		def [](key)
			@attributes[key.to_sym]
		end

		def to_hash_value(value, type)
			case value
			when PagarMeObject
				value.send type
			when Array
				value.map do |v|
					to_hash_value v, type
				end
			else
				value
			end
		end

		def unsaved_values
			Hash[@unsaved_values.map { |k| [k, to_hash_value(@attributes[k], 'unsaved_values')] }]
		end

		def to_hash
			Hash[@attributes.map { |k, v| [k, to_hash_value(v, 'to_hash')] }]
		end

		protected

		def method_missing(name, *args)
			name = name.to_s

			if name.end_with?('=')
				attribute_name = name[0...-1]

				@attributes[attribute_name] = args[0]
				@unsaved_values.add(attribute_name)
			else
				@attributes[name] || nil
			end
		end
	end
end

