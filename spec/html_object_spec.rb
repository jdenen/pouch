require 'spec_helper'

describe Pouch::HTMLObject do
  let(:browser){ double("Watir::Browser") }
  let(:element){ double("Watir::HTMLElement")}
  let(:object){ Pouch::HTMLObject.new(browser, id: 'foo') }

  context "when a missing method is called" do
    it "passes the method to the webdriver element" do
      expect(browser).to receive(:element).with(id: 'foo').and_return(element)
      expect(element).to receive(:click)
      object.click      
    end

    it "returns the target object" do
      class NextPage; include Pouch; end
      expect(browser).to receive(:element).with(id: 'bar').and_return(element)
      expect(element).to receive(:click)
      expect(Pouch::HTMLObject.new(browser, {id: 'bar'}, NextPage).click).to be_a NextPage      
    end
  end
  
  describe "#html_element" do
    it "finds an element through its webdriver" do
      expect(browser).to receive(:element).with(id: 'foo')
      object.html_element
    end
  end
end
