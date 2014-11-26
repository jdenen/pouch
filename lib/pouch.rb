require "pouch/version"

module Pouch

  class ContextualReplacementError < StandardError; end
  
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
    contextualize_methods
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

  def element tag, name, identifier, *args, &block
    define_method name do
      return browser.element_for tag, identifier unless block_given?
      block.call browser.send('element_for', tag, identifier), *args
    end
  end

  private

  def contextualize_methods
    return unless context
    context.each_with_object([]) do |ctxt, array|
      next unless array.flatten.empty?
      array << match_and_replace(ctxt)
    end
  end

  def match_and_replace context
    get_match(context).map{ |mthd| self.method mthd }.each{ |mthd| replace_method mthd, context }
  end

  def get_match context
    methods.select{ |mthd| mthd.to_s.start_with? "#{context}_" }.each_with_object([]) do |mthd, array|
      unless respond_to? mthd.to_s.gsub("#{context}_", "")
        raise ContextualReplacementError, "#{self.class} defined no standard method for replacement '#{mthd}'"
      end
      array << mthd
    end
  end

  def replace_method method, context
    (class << self; self; end).class_eval{ define_method method.name.to_s.gsub("#{context}_",""), method }
  end

  def standardize context
    context.map!{ |c| standardize c } if context.kind_of? Array
      
    if [Array, String, Symbol].include? context.class
      [context].flatten.map(&:to_s)
    else
      raise "Cannot define Pouch context as #{context.class}"
    end
  end
  
end
