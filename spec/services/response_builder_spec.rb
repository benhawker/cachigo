require 'rails_helper'

describe ResponseBuilder do

  let(:params) do 
    {
      checkin:     '01012017',
      checkout:    '020012017',
      destination: 'Istanbul',
      guests:      2,
      suppliers:   'supplier1,supplier2'
    }
  end

  let(:supplier1_response) do
    {
      "abcd": 340.2,
      "defg": 320.49,
      "mnop": 317.0
    }
  end

  let(:supplier2_response) do
    {
      "abcd": 299.9,
      "mnop": 340.33
    }
  end

  let(:supplier3_response) do
    {
      "abcd": 300.2,
      "defg": 403.22,
      "mnop": 288.3
    }
  end

  let(:cache) { Cache }

  subject { described_class.new(params: params, cache_store: cache) }

  before do 
    allow(subject).to receive(:supplier_response).with(:supplier1) { supplier1_response }
    allow(subject).to receive(:supplier_response).with(:supplier2) { supplier2_response }
    allow(subject).to receive(:supplier_response).with(:supplier3) { supplier3_response }
  end

  describe "#build" do
    context "missing parameters" do
      it "returns a message about the missing params" do
        params.delete(:checkin)
        expect(subject.build).to eq ({error: "Payload missing required keys: checkin"})
      end

      it "returns a message for multiple missing params" do
        params.delete(:checkin)
        params.delete(:checkout)
        expect(subject.build).to eq ({error: "Payload missing required keys: checkin, checkout"})
      end
    end

    context "valid params" do
      context "for all suppliers" do
        before { params.delete(:suppliers) }

        let(:expected_response) do
          {
            data: [
                    {:id=>:abcd, :price=>299.9, :supplier=>:supplier2}, 
                    {:id=>:defg, :price=>320.49, :supplier=>:supplier1}, 
                    {:id=>:mnop, :price=>288.3, :supplier=>:supplier3}
                  ]
          }
        end

        it "returns all properties with the lowest price shown" do
          expect(subject.build).to eq expected_response
        end
      end

      context "for only supplier1 and supplier2" do
        let(:expected_response) do
          {
            data: [
                    {:id=>:abcd, :price=>299.9, :supplier=>:supplier2}, 
                    {:id=>:defg, :price=>320.49, :supplier=>:supplier1}, 
                    {:id=>:mnop, :price=>317.0, :supplier=>:supplier1}
                  ]
          }
        end

        it "returns all properties with the lowest price shown" do
          expect(subject.build).to eq expected_response
        end
      end
    end

    context "caching" do
      it "does not error if their is no cache" do
        cache = nil
        expect{ subject.build }.not_to raise_error
      end

      it "stores the value to the cache" do
        subject.cache_store.store.clear
        
        expect(subject.cache_store).to receive(:set).once.with("01012017020012017istanbul2supplier1", supplier1_response)
        expect(subject.cache_store).to receive(:set).once.with("01012017020012017istanbul2supplier2", supplier2_response)

        subject.build
      end

      it "retrieves the value from the cache if present" do
        expect(subject.cache_store).to receive(:get).once.with("01012017020012017istanbul2supplier1")
        expect(subject.cache_store).to receive(:get).once.with("01012017020012017istanbul2supplier2")

        subject.build
      end

      it "does not retrieve the value the cache_store from when a param has been changed" do
        params[:destination] = "Singapore"
        # expect(subject.cache_store).not_to receive(:get).with("01012017020012017singapore2supplier1")
        expect(subject.cache_store).to receive(:set).once.with("01012017020012017singapore2supplier1", {:abcd=>299.9, :mnop=>340.33})
        
        subject.build
      end
    end
  end

  describe "#parsed_suppliers" do
    it "returns all suppliers" do
      expect(subject.send(:parsed_suppliers)).to eq [:supplier1, :supplier2]
    end

    it "returns the given suppliers as an array of symbols" do
      params.delete(:suppliers)
      expect(subject.send(:parsed_suppliers)).to eq [:supplier1, :supplier2, :supplier3]
    end 
  end
end