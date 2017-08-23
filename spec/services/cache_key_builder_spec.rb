require 'rails_helper'

describe CacheKeyBuilder do

  let(:params) do 
    {
      checkin:     '01012017',
      checkout:    '020012017',
      destination: 'Istanbul',
      guests:      2,
      suppliers:   'supplier1,supplier2'
    }
  end

  let(:supplier) { :supplier1 }

  subject { described_class.new(params, supplier) }

  describe "#build" do
    it "returns a key" do
      expect(subject.build).to eq "01012017020012017istanbul2supplier1"
    end
  end
end