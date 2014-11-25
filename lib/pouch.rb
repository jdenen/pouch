require "pouch/version"

module Pouch
  
  def self.included base
    base.extend self
  end

  def initialize browser, start = false, opts = {}
    if start.is_a?(Hash) && opts.empty?
      opts = start
      start = false
    end
    
    @browser = browser
    @context = standardize opts[:context] if opts[:context]
    visit if self.respond_to?(:visit) && start
  end

  def browser
    @browser
  end

  def context
    @context
  end

  def page_url= str
    define_method :visit do
      self.browser.goto str
    end
  end

  private

  def standardize context
    context.map!{ |c| standardize c } if context.kind_of? Array
      
    if [Array, String, Symbol].include? context.class
      [context].flatten.map(&:to_s)
    else
      raise "Cannot define Pouch context as #{context.class}"
    end
  end
  
end
