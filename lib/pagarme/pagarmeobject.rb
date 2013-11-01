module PagarMe
  class PagarMeObject

	if method_defined?(:id)
	  undef :id
	end

	def initialize(response = {})
	  @attributes = {}
	  update(response)
	end

	def self.build(attributes)
	  object = self.new(attributes)
	  return object
	end

	def update(attributes)
	  instance_eval do
		remove_attribute(@attributes.keys)
		add_attribute(attributes.keys)
	  end
	  @attributes = Hash.new

	  attributes.each do |key,value|
		@attributes[key] = Util.convert_to_pagarme_object(value)
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

	def to_hash
	  @attributes.each do |k,v|
			@attributes[k] = @attributes[k].to_hash if @attributes[k].kind_of?(PagarMeObject) 	
	  end
	end

	protected

	def metaclass
	  class << self; self; end
	end


	def remove_attribute(keys)
	  metaclass.instance_eval do
		keys.each do |key|
		  key_sym = :"#{key}="
		  remove_method(key) if method_defined?(key)
		  remove_method(key_sym) if method_defined?(key_sym)
		end
	  end
	end

	def add_attribute(keys)
	  metaclass.instance_eval do
		keys.each do |key| 
		  key_set = "#{key}="
		  define_method(key) { @attributes[key] }
		  define_method(key_set) do |value|
			if v == ""
			  raise ArgumentError.new("Voce nao pode atribuir a #{key} uma string vazia.")
			end
			@attributes[key] = value
		  end
		end
	  end
	end

	def method_missing(name, *args)
	  if name.to_s.end_with?('=')
		attr = name.to_s[0...-1].to_sym
		add_attribute([attr])
		begin
		  mth = method(name)
		rescue NameError
		  raise NoMethodError.new("O atributo #{name} nao e permitido.")
		end
		return mth.call(args[0])
	  else
		return @attributes[name] if @attributes.has_key?(name)
	  end
	end
  end
end
