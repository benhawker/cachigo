require 'rails_helper'

describe Cache do
  let(:klass) { Cache }
  
  after do
    klass.store.clear
  end

  describe "set" do
    it "sets a new value in the store" do
      expired_at = Time.now + 5.minutes
      value = klass.set(:a_key, 5)
      expect(value).to be_an Array
      expect(value[0]).to eq 5
      expect(value[1]).to be_within(0.01).of(expired_at)
    end

    it "overrides the value if already found" do
      klass.set(:a_key, 5)
      value = klass.set(:a_key, 10)
      expect(value[0]).to eq 10
    end

    it "sets a custom expiry" do
      expired_at = (Time.now + 20.minutes)
      value = klass.set(:a_key, 10, expired_at: expired_at)
      expect(value).to eq [10, expired_at]
    end
  end

  describe "get" do
    it "returns the value when given a symbol" do
      klass.set(:a_key, 10)
      value = klass.get(:a_key)
      expect(value).to eq 10
    end

    it "returns the value when given a string" do
      klass.set(:a_key, 10)
      value = klass.get("a_key")
      expect(value).to eq 10
    end

    it "returns nil if the key is not present" do
      value = klass.get("a_key")
      expect(value).to eq nil
    end

    it "returns nil if expired" do
      now = Time.now
      allow(Time).to receive(:now).and_return(now)

      klass.set("a_key", 1, expired_at: now - 1)
      value = klass.get("a_key")
      expect(value).to eq nil
    end
  end
end
