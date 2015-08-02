module Pouch::DSL
  module Elements
    
    class VisibilityError < StandardError; end
    class PresenceError < StandardError; end
    
    def element tag, name, identifier, *args, &block
      define_method name, ->(time = nil) do
        timer(time){ browser.element(tag, identifier).visible? }
        return browser.element tag, identifier unless block_given?
        block.call browser.send(:element, tag, identifier), *args        
      end

      define_waiting_methods tag, name, identifier, *args, &block
    end
                     
    def button name, identifier, *args, &block
      element :button, name, identifier, args, &block
    end

    def checkbox name, identifier, *args, &block
      identifier.merge! type: 'checkbox'
      element :input, name, identifier, args, &block
    end

    def div name, identifier, *args, &block
      element :div, name, identifier, args, &block
    end

    def file_field name, identifier, *args, &block
      identifier.merge! type: 'file'
      element :input, name, identifier, args, &block
    end

    def form name, identifier, *args, &block
      element :form, name, identifier, args, &block
    end

    def h1 name, identifier, *args, &block
      element :h1, name, identifier, args, &block
    end

    def h2 name, identifier, *args, &block
      element :h2, name, identifier, args, &block
    end

    def h3 name, identifier, *args, &block
      element :h3, name, identifier, args, &block
    end

    def h4 name, identifier, *args, &block
      element :h4, name, identifier, args, &block
    end

    def h5 name, identifier, *args, &block
      element :h5, name, identifier, args, &block
    end

    def h6 name, identifier, *args, &block
      element :h6, name, identifier, args, &block
    end

    def image name, identifier, *args, &block
      element :img, name, identifier, args, &block
    end

    def link name, identifier, *args, &block
      element :a, name, identifier, args, &block
    end

    def list_item name, identifier, *args, &block
      element :li, name, identifier, args, &block
    end

    def ordered_list name, identifier, *args, &block
      element :ol, name, identifier, args, &block
    end

    def paragraph name, identifier, *args, &block
      element :p, name, identifier, args, &block
    end

    def radio_button name, identifier, *args, &block
      identifier.merge! type: 'radio'
      element :input, name, identifier, args, &block
    end

    def select_list name, identifier, *args, &block
      element :select, name, identifier, args, &block
    end

    def span name, identifier, *args, &block
      element :span, name, identifier, args, &block
    end

    def table name, identifier, *args, &block
      element :table, name, identifier, args, &block
    end

    def table_cell name, identifier, *args, &block
      element :td, name, identifier, args, &block
    end

    def table_header name, identifier, *args, &block
      element :th, name, identifier, args, &block
    end

    def table_row name, identifier, *args, &block
      element :tr, name, identifier, args, &block
    end

    def text_area name, identifier, *args, &block
      element :textarea, name, identifier, args, &block
    end

    def text_field name, identifier, *args, &block
      element :input, name, identifier, args, &block
    end

    def unordered_list name, identifier, *args, &block
      element :ul, name, identifier, args, &block
    end

    private

    def define_waiting_methods tag, name, identifier, *args, &block
      define_method "when_#{name}_not_visible", ->(time = nil) do
        result = negative_timer(time){ !browser.element(tag, identifier).visible? }
        unless result
          raise VisibilityError, "#{name} element is still visible"
        end
        self
      end
      
      define_method "when_#{name}_present", ->(time = nil) do
        timer(time){ browser.element(tag, identifier).present? }
        html_element = browser.element tag, identifier
        return located_element unless block_given?
        block.call located_element, *args
      end

      define_method "when_#{name}_not_present", ->(time = nil) do
        result = negative_timer(time){ !browser.element(tag, identifier).present? }
        unless result
          raise PresenceError, "#{name} element is still present"
        end
        self
      end
    end

    def timer n, &block
      interval = n.nil? ? timeout : n
      timed_out = Time.now + timeout
      until Time.now > timed_out
        result = yield block rescue false
        break if result
      end
    end

    def negative_timer n, &block
      interval = n.nil? ? timeout : n
      timed_out = Time.now + interval
      until Time.now > timed_out
        result = yield block rescue false
        return result if result
      end
      false
    end

  end
end
