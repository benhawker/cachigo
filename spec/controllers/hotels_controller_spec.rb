require 'rails_helper'

describe HotelsController do
  let(:params) do
    {
      "checkin": "123",
      "checkout": "123",
      "destination": "Istanbul",
      "guests": "2",
      "suppliers": "supplier1,supplier3",
    }
  end

  describe "GET #index" do

    context "missing paramters" do
      it "returns an appropriate message" do
        get :index, params: { format: :json }

        expect(response.code).to eq "422"

        result = JSON.parse(response.body)
        expect(result).to eq (
          {"error"=>"Payload missing required keys: checkin, checkout, destination, guests"})
      end
    end

    context "valid request" do
      it  "returns a list of hotels" do
        get :index, params: params
        
        expect(response.code).to eq "200"
        result = JSON.parse(response.body)

        expect(result).to eq(
          {"data"=>
            [
              {"id"=>"abcd", "price"=>300.2, "supplier"=>"supplier1"}, 
              {"id"=>"defg", "price"=>320.49, "supplier"=>"supplier3"}, 
              {"id"=>"mnop", "price"=>288.3, "supplier"=>"supplier1"}
            ]
          }
        )
      end
    end
  end
end