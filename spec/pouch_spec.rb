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
        Page2.new driver, true, context: 'test'
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
        Page2.new driver, true, context: 'test'
      end
    end

    context "with context" do
      obj = ->(context){ Page2.new 'webdriver', context: context }
      
      it "defines @context with String argument" do
        expect(obj.call('my_context').instance_variable_get :@context).to eq ['my_context']
      end

      it "defines @context with Array argument" do
        expect(obj.call(['my_context']).instance_variable_get :@context).to eq ['my_context']
      end

      it "defines @context with Symbol argument" do
        expect(obj.call(:my_context).instance_variable_get :@context).to eq ['my_context']
      end
      
      it "defines @context with two Strings" do
        expect(obj.call(['one', 'two']).instance_variable_get :@context).to eq ['one', 'two']
      end

      it "defines @context with two Arrays" do
        expect(obj.call([['one'], ['two']]).instance_variable_get :@context).to eq ['one', 'two']
      end

      it "defines @context with two Symbols" do
        expect(obj.call([:one, :two]).instance_variable_get :@context).to eq ['one', 'two']
      end

      it "defines @context with one String and one Array" do
        expect(obj.call(['one', [:two]]).instance_variable_get :@context).to eq ['one', 'two']
      end

      it "defines @context with combination of Array, String, and Symbol" do
        given = [:one, 'two', [:three, [:four, 'five'], :six], 'seven', ['eight', [['nine', [:ten]]]]]
        expected = ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine', 'ten']
        expect(obj.call(given).instance_variable_get :@context).to eq expected
      end

      it "raises StandardError with Hash argument" do
        expect{ obj.call({}) }.to raise_error(StandardError, /Hash/)
      end

      it "raises StandardError if one argument is a Number" do
        expect{ obj.call(['one', 2]) }.to raise_error(StandardError, /Fixnum/)
      end
    end
  end

  class Page3
    include Pouch
    element(:a, :generic, id: 'generic')
    element(:a, :blocked, id: 'blocked'){ |link| link.href }
    element(:a, :different_generic, id: 'generic-diff')
    element(:a, :different_blocked, id: 'blocked-diff'){ |link| link.href }
    element(:a, :what_replacement, id: 'no-match')
  end

  describe "#browser" do
    it "returns the browser instance" do
      obj = Page3.new 'webdriver'
      expect(obj.browser).to eq 'webdriver'
    end
  end

  describe "#context" do
    it "returns the page object context" do
      obj = Page3.new 'webdriver', context: ['one', :two, ['three']]
      expect(obj.context).to eq ['one', 'two', 'three']
    end
  end

  describe "#element" do
    let(:browser){ double 'webdriver' }
    let(:element){ double 'html_link' }
    let(:page){ Page3.new browser }
    let(:diff){ Page3.new browser, context: 'different' }
    let(:what){ Page3.new browser, context: 'what' }

    it "returns the link element by default" do
      expect(browser).to receive(:element_for).with(:a, id:'generic').and_return(element)
      expect(page.generic).to eq element
    end

    it "returns an element that can be clicked" do
      expect(browser).to receive(:element_for).with(:a, id:'generic').and_return(element)
      expect(element).to receive(:click)
      page.generic.click
    end

    it "returns the result of the definition block" do
      expect(browser).to receive(:element_for).with(:a, id:'blocked').and_return(element)
      expect(element).to receive(:href).and_return("www.test.com")
      expect(page.blocked).to eq "www.test.com"
    end

    context "with context" do
      it "uses the replacement method" do
        expect(browser).to receive(:element_for).with(:a, id:'generic-diff').and_return(element)
        expect(diff.generic).to eq element
      end

      it "uses the replacement method with definition block" do
        expect(browser).to receive(:element_for).with(:a, id:'blocked-diff').and_return(element)
        expect(element).to receive(:href).and_return("www.diff.com")
        expect(diff.blocked).to eq "www.diff.com"
      end

      it "uses the standard method when context matches no replacement" do
        expect(browser).to receive(:element_for).with(:a, id:'generic').and_return(element)
        expect(Page3.new(browser, context: 'test').generic).to eq element
      end

      it "throws an error with replacement but no standard method" do
        expect{ what.replacement }.to raise_error Pouch::ContextualReplacementError, /Page3 defined no standard method for replacement/
      end
    end
  end
  
end
