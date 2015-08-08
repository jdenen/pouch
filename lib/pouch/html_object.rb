module Pouch
  class HTMLObject
    def initialize browser, identifier, target = nil
      @browser    = browser
      @identifier = identifier
      @target     = target
    end

    def html_element
      @browser.send(:element, @identifier)
    end

    def method_missing mthd, *args
      html_element.send(mthd, *args)
      return @target.new(@browser) unless @target.nil?
    end
  end
end
