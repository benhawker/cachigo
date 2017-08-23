# +CacheKeyBuilder+
# Returns a key to be used in the Cache based on the
# specified params + the specific supplier
#
# Usage: 
#   c = CacheKeyBuilder.new(params_hash, :supplier1)
#   c.build
#
# Sample return: "01012017020012017istanbul2supplier1"

class CacheKeyBuilder
  
  attr_reader :params, :supplier

  def initialize(params, supplier)
    @params = params
    @supplier = supplier
  end

  def build
    params.delete(:suppliers)
    (params.values.join('') + supplier.to_s).downcase
  end

end