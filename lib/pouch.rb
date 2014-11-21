require "pouch/version"

module Pouch
  
  def self.included base
    base.extend self
  end

  def initialize browser, start = false
    @browser = browser
    visit if self.respond_to?(:visit) && start
  end

  def browser
    @browser
  end

  def page_url= str
    define_method :visit do
      self.browser.goto str
    end
  end
  
end
