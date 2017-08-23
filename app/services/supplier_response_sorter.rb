# Sorts the aggregated responses from the suppliers, filtering the hotels
# and selecting the lowest priced supplier for each hotel.

class SupplierResponseSorter
  attr_reader :supplier_responses

  def initialize(supplier_responses)
    @supplier_responses = supplier_responses
  end

  def sort
    find_lowest_price(sort_by_hotel)
  end

  private

  def find_lowest_price(sorted_by_hotel)
    response = []

    sorted_by_hotel.each do |hotel, price_and_supplier_array|
      if price_and_supplier_array.size === 1
        response << { id: hotel }.merge!(price_and_supplier_array[0])
      else
        response << { id: hotel }.merge!(price_and_supplier_array.min_by{ |x| x[:price] })
      end
    end

    response
  end

  def sort_by_hotel
    new_map = {}

    supplier_responses.each do |supplier, hotel_and_price|
      hotel_and_price.each do |hotel, price|
        if new_map[hotel]
          new_map[hotel] << { price: price, supplier: supplier}
        else
          new_map[hotel] = [ { price: price, supplier: supplier} ]
        end
      end
    end 

    new_map
  end

end