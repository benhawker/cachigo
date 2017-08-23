# Usage: ResponseBuilder.new(params_hash)
# The goal of this class is to use all the components involved in building the response.

class MissingParametersError < StandardError
  def initialize(missing_keys)
    super("Payload missing required keys: #{missing_keys.join(", ")}")
  end
end

class ResponseBuilder
  REQUIRED_KEYS = [:checkin, :checkout, :destination, :guests]
  SUPPLIERS = YAML.load_file(Rails.configuration.suppliers_data)

  attr_reader :params, :cache_store

  def initialize(params:, cache_store: nil)
    @params = params
    @cache_store = cache_store
  end

  def build
    validate_parameters!
    supplier_responses = {}

    parsed_suppliers.each do |supplier|
      key = CacheKeyBuilder.new(params, supplier).build

      if cache_store
        supplier_responses[supplier] = if cache_store.get(key)
          cache_store.get(key)
        else
          resp = supplier_response(supplier)
          cache_store.set(key, resp)
          resp
        end
      else
        supplier_responses[supplier] = supplier_response(supplier)
      end
    end    

    { data: SupplierResponseSorter.new(supplier_responses).sort }

    rescue MissingParametersError => e
      { error: e.message }
  end

  private

  def validate_parameters!
    required_keys = REQUIRED_KEYS.dup
    missing_keys = []

    required_keys.each do |key|
      if params[key].blank?
        missing_keys << key
      end
    end

    if missing_keys.present?
      raise MissingParametersError.new(missing_keys)
    end
  end

  def supplier_response(supplier)
    SupplierCaller.new(supplier).call
  end

  def parsed_suppliers
    if params[:suppliers].nil?
      SUPPLIERS.keys
    else
      params[:suppliers].split(",").map(&:to_sym)
    end
  end

end