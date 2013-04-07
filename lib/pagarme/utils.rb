class Hash
  def to_params
	self.collect{ |key, value| "#{key}=#{value}" }.join('&')
  end
end
