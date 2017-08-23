# +SupplierCaller+ Makes a request to the supplier api and returns a parsed response.
#
# Note: At present there is no error handling.
#
# Usage: 
#   caller = SupplierCaller.new(:supplier1)
#   caller.call

class SupplierCaller
  include HTTParty
  base_uri 'https://api.myjson.com'

  SUPPLIERS = YAML.load_file(Rails.configuration.suppliers_data)

  attr_reader :supplier

  def initialize(supplier)
    @supplier = supplier
  end

  def call
    self.class.get(SUPPLIERS[supplier]).parsed_response
  end
end 