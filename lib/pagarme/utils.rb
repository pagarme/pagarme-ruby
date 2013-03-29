require 'uri'

class Hash
  def to_params
	URI.escape(self.collect{ |key, value| "#{key}=#{value}" }.join('&'))
  end
end
