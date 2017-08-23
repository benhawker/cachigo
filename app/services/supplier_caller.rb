# +SupplierCaller+ Makes a request to the supplier api and returns a parsed response.
#
# Note: At present there is very limited error handling.
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
    resp = self.class.get(SUPPLIERS[supplier])
  
    # If the supplier api does not return 200 do not return the parsed response.
    resp["status"] && resp["status"] != 200 ? {} : resp.parsed_response
  end
end 