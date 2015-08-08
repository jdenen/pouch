module Pouch
  class HTMLObject
    attr_reader :browser, :tag, :identifier, :target
    
    def initialize browser, tag, identifier, target = nil
      @browser    = browser
      @tag        = tag
      @identifier = identifier
      @target     = target
    end

    def html_element
      xpath = parse_into_xpath
      browser.send(:element, xpath: xpath)
    end

    def parse_into_xpath
      id    = identifier.dup
      index = id.delete(:index)
      
      query = id.map do |k, v|
        v.is_a?(Regexp) ?
          "[contains(@#{k}, '#{v.source}')]" :
          "[@#{k}='#{v}']" 
      end.join
      
      index ? "(//#{tag}#{query})[#{index}]" : "//#{tag}#{query}"
    end

    private

    def method_missing mthd, *args
      html_element.send(mthd, *args)
      return target.new(browser) unless target.nil?
    end
  end
end
