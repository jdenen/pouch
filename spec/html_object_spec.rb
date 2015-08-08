require 'spec_helper'

describe Pouch::HTMLObject do
  let(:browser){ double("Watir::Browser") }
  let(:element){ double("Watir::HTMLElement")}
  let(:object){ Pouch::HTMLObject.new(browser, :a, id: 'foo') }
  let(:xpath){ "//a[@id='foo']" }

  context "when a missing method is called" do
    it "passes the method to the webdriver element" do
      expect(browser).to receive(:element).with(xpath: xpath).and_return(element)
      expect(element).to receive(:click)
      object.click      
    end

    it "returns the target object" do
      class NextPage; include Pouch; end
      expect(browser).to receive(:element).with(xpath: xpath).and_return(element)
      expect(element).to receive(:click)
      expect(Pouch::HTMLObject.new(browser, :a, {id: 'foo'}, NextPage).click).to be_a NextPage 
    end
  end
  
  describe "#html_element" do
    it "finds an element through its webdriver" do
      expect(browser).to receive(:element).with(xpath: xpath)
      object.html_element
    end
  end

  describe "#parse_into_xpath" do
    it "generates an XPath for the element" do
      expect(object.parse_into_xpath).to start_with("//a")
    end

    it "generates an XPath query from identifier" do
      expect(object.parse_into_xpath).to end_with("[@id='foo']")
    end

    context "when identified by Regexp" do
      it "generates a query with the contains function" do
        obj = Pouch::HTMLObject.new(browser, :a, id: /foo/)
        expect(obj.parse_into_xpath).to end_with("[contains(@id, 'foo')]")
      end
    end

    context "when identified by multiple attributes" do
      it "generates a multi-part query" do
        obj = Pouch::HTMLObject.new(browser, :a, id: 'foo', name: 'bar')
        expect(obj.parse_into_xpath).to end_with("[@id='foo'][@name='bar']")
      end
    end

    context "when identified by index" do
      it "wraps the XPath query in an index" do
        obj = Pouch::HTMLObject.new(browser, :a, index: 1)
        expect(obj.parse_into_xpath).to eq "(//a)[1]"
      end
    end

    context "when identified with multiple parameters" do
      it "correctly generates an XPath" do
        obj = Pouch::HTMLObject.new(browser, :div, index: 3, id: 'foo', name: /bar/)
        expect(obj.parse_into_xpath).to eq "(//div[@id='foo'][contains(@name, 'bar')])[3]"
      end
    end
  end
end
