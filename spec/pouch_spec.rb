require 'spec_helper'

describe Pouch do
  
  describe ".included" do
    class Page; end
    
    it "extends Pouch onto the base class" do
      expect(Page).to receive(:extend).with(Pouch)
      Page.send(:include, Pouch)
    end
  end

  describe "#initialize" do
    class Page2; include Pouch; end
    
    it "creates @browser variable" do
      obj = Page2.new 'webdriver'
      expect(obj.instance_variable_get :@browser).to eq 'webdriver'
    end
        
    context "when instance does not respond to #visit" do
      it "doesn't navigate to page_url if start=true" do
        driver = double 'webdriver'
        expect(driver).to_not receive(:goto).with('url')
        Page2.new driver, true
      end

      it "doesn't navigate to page_url if start=false" do
        driver = double 'webdriver'
        expect(driver).to_not receive(:goto).with('url')
        Page2.new driver, false
      end
    end

    context "when instance responds to #visit" do
      it "doesn't navigate to page_url if start=false" do
        Page2.send :page_url=, 'url'
        driver = double 'webdriver'
        expect(driver).to_not receive(:goto)
        Page2.new driver, false
      end

      it "navigates to page_url if start=true" do
        driver = double 'webdriver'
        expect(driver).to receive(:goto).with('url')
        Page2.new driver, true
      end
    end
  end

  describe "#browser" do
    class Page3; include Pouch; end
    it "returns the browser instance" do
      obj = Page3.new 'webdriver'
      expect(obj.browser).to eq 'webdriver'
    end
  end
  
end
