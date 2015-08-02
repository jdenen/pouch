require 'spec_helper'

describe Pouch::DSL::Attributes do

  class Page
    include Pouch
    url "www.foo.com"
  end

  class EmptyPage
    include Pouch
  end

  let(:browser){ double 'webdriver' }
  let(:page){ Page.new browser }
  let(:empty){ EmptyPage.new browser }
  
  describe "#url" do
    context "when called on a class" do
      it "creates the :url instance method" do
        expect(page.url).to eq "www.foo.com"
      end

      it "creates #visit on the instance" do
        expect(browser).to receive(:goto).with("www.foo.com")
        page.visit
      end
    end

    context "when unused on a class" do
      it "returns nil" do
        expect(empty.url).to eq nil
      end

      it "does not create #visit on the instance" do
        expect(empty).to_not respond_to(:visit)
      end
    end
  end
  
end


