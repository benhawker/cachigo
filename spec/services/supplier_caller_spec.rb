require 'rails_helper'

describe SupplierCaller do

  let(:supplier) { :supplier1 }
  subject { described_class.new(supplier) }

  describe "#call" do
    context "successful request" do
      let(:expected_response) do
        {
          "abcd"=>300.2, 
          "defg"=>403.22, 
          "mnop"=>288.3
        }
      end
    
      it "returns the response.body from the supplier" do
        expect(subject.call).to eq expected_response
      end
    end

    context "failed request" do
      it "handles the error" do
        #EXTENSION
      end
    end
  end
end