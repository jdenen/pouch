module Pouch
  module Elements

    def element tag, name, identifier, *args, &block
      define_method name do
        return browser.element tag, identifier unless block_given?
        block.call browser.send(:element, tag, identifier), *args
      end
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

  end
end