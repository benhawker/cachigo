require 'rails_helper'

describe SupplierResponseSorter do

  let(:supplier_responses) do
    {
      :supplier1=>{:abcd=>300.2, :defg=>403.22, :mnop=>288.3}, 
      :supplier2=>{:abcd=>299.9, :mnop=>340.33}, 
      :supplier3=>{:abcd=>340.2, :defg=>320.49, :mnop=>317.0}
    }
  end

  subject { described_class.new(supplier_responses) }

  describe "#sort" do
    let(:expected_return) do
      [
        {:id=>:abcd, :price=>299.9, :supplier=>:supplier2}, 
        {:id=>:defg, :price=>320.49, :supplier=>:supplier3}, 
        {:id=>:mnop, :price=>288.3, :supplier=>:supplier1}
      ]
    end

    it "returns data for each property with the lowest price supplier chosen" do
      expect(subject.sort).to eq expected_return
    end
  end

end