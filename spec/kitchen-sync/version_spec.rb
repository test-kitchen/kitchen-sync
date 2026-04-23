require "spec_helper"
require "kitchen-sync"

describe KitchenSync do
  describe "VERSION" do
    it "is defined" do
      expect(KitchenSync::VERSION).not_to be_nil
    end

    it "is a non-empty string" do
      expect(KitchenSync::VERSION).to be_a(String)
      expect(KitchenSync::VERSION).not_to be_empty
    end

    it "is frozen" do
      expect(KitchenSync::VERSION).to be_frozen
    end

    it "looks like a semantic version" do
      expect(KitchenSync::VERSION).to match(/\A\d+\.\d+\.\d+/)
    end
  end
end
