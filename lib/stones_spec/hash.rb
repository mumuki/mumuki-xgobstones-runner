class Hash
  def map_values(&block)
    Hash[self.map {|k, v| [k, block.call(k,v)] }]
  end
end