module Pouch::DSL
  module Attributes

    def url address = nil
      return nil if address.nil?
      
      define_method :url, ->(uri = address) do
        uri
      end
      
      define_method :visit do
        browser.goto url 
      end
    end
    
  end
end
