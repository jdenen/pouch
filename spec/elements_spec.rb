require 'spec_helper'
require './lib/pouch/elements'

describe Pouch::Elements do

  class Page
    include Pouch
    element(:a, :generic, id: 'generic')
    element(:a, :blocked, id: 'blocked'){ |link| link.href }
    element(:a, :different_generic, id: 'generic-diff')
    element(:a, :different_blocked, id: 'blocked-diff'){ |link| link.href }
    element(:a, :what_replacement, id: 'no-match')
  end

  let(:browser){ double 'webdriver', :element => element }
  let(:element){ double 'html_link', :visible? => true }
  let(:page){ Page.new browser }
  let(:diff){ Page.new browser, context: 'different' }
  let(:what){ Page.new browser, context: 'what' }

  describe "#element" do
    it "returns the link element by default" do
      expect(page.generic).to eq element
    end

    it "returns the result of the definition block" do
      expect(element).to receive(:href).and_return("www.test.com")
      expect(page.blocked).to eq "www.test.com"
    end

    it "calls #timer to wait for visible element" do
      expect(page).to receive(:timer)
      page.generic
    end

    it "generates #when_generic_not_visible" do
      expect(page).to respond_to :when_generic_not_visible
    end

    it "generates #when_generic_present method" do
      expect(page).to respond_to :when_generic_present
    end

    it "generates #when_generic_not_present method" do
      expect(page).to respond_to :when_generic_not_present
    end

    context "with context" do
      it "uses the replacement method" do
        expect(browser).to receive(:element).twice.with(:a, id:'generic-diff')
        expect(diff.generic).to eq element
      end

      it "uses the replacement method with definition block" do
        expect(element).to receive(:href).and_return("www.diff.com")
        expect(diff.blocked).to eq "www.diff.com"
      end

      it "uses the standard method when context matches no replacement" do
        expect(browser).to receive(:element).twice.with(:a, id:'generic')
        expect(Page.new(browser, context: 'test').generic).to eq element
      end

      it "throws an error with replacement but no standard method" do
        expect{ what.replacement }.to raise_error Pouch::ReplacementError, /Page defined no standard method for replacement/
      end
    end
  end

  describe "#when_element_not_visible" do
    Page.send(:link, :invisible, id:'hidden')

    let(:page){ Page.new 'webdriver' }
    
    it "returns the page object instance if valid" do
      expect(page).to receive(:negative_timer).and_return(true)
      expect(page.when_invisible_not_visible).to eq page
    end

    it "raises an VisibilityError if invalid" do
      expect(page).to receive(:negative_timer).and_return(false)
      expect{ page.when_invisible_not_visible }.to raise_error Pouch::VisibilityError, /invisible element/
    end
  end

  describe "#when_element_not_present" do
    Page.send(:link, :gone, id:'not-here')

    let(:page){ Page.new 'webdriver' }

    it "returns the page object instance if valid" do
      expect(page).to receive(:negative_timer).and_return(true)
      expect(page.when_gone_not_present).to eq page
    end

    it "raises a PresenceError if invalid" do
      expect(page).to receive(:negative_timer).and_return(false)
      expect{ page.when_gone_not_present }.to raise_error Pouch::PresenceError, /gone element/
    end
  end

  describe "#button" do
    it "calls :element with :button tag" do
      expect(page).to receive(:element).with(:button, :button_name, {id: 'id'}, [])
      page.send(:button, :button_name, id: 'id')
    end
  end

  describe "#checkbox" do
    it "calls :element with :input tag" do
      expect(page).to receive(:element).with(:input, :checkbox_name, {id: 'id', type: 'checkbox'}, [])
      page.send(:checkbox, :checkbox_name, id: 'id')
    end
  end

  describe "#div" do
    it "calls :element with :div tag" do
      expect(page).to receive(:element).with(:div, :div_name, {id: 'id'}, [])
      page.send(:div, :div_name, id: 'id')
    end
  end

  describe "#file_field" do
    it "calls :element with :input tag" do
      expect(page).to receive(:element).with(:input, :ff_name, {id: 'id', type: 'file'}, [])
      page.send(:file_field, :ff_name, id: 'id')
    end
  end

  describe "#form" do
    it "calls :element with :form tag" do
      expect(page).to receive(:element).with(:form, :form_name, {id: 'id'}, [])
      page.send(:form, :form_name, id: 'id')
    end
  end

  describe "#h1" do
    it "calls :element with :h1 tag" do
      expect(page).to receive(:element).with(:h1, :h1_name, {id: 'id'}, [])
      page.send(:h1, :h1_name, id: 'id')
    end
  end

  describe "#h2" do
    it "calls :element with :h2 tag" do
      expect(page).to receive(:element).with(:h2, :h2_name, {id: 'id'}, [])
      page.send(:h2, :h2_name, id: 'id')
    end
  end

  describe "#h3" do
    it "calls :element with :h3 tag" do
      expect(page).to receive(:element).with(:h3, :h3_name, {id: 'id'}, [])
      page.send(:h3, :h3_name, id: 'id')
    end
  end

  describe "#h4" do
    it "calls :element with :h4 tag" do
      expect(page).to receive(:element).with(:h4, :h4_name, {id: 'id'}, [])
      page.send(:h4, :h4_name, id: 'id')
    end
  end

  describe "#h5" do
    it "calls :element with :h5 tag" do
      expect(page).to receive(:element).with(:h5, :h5_name, {id: 'id'}, [])
      page.send(:h5, :h5_name, id: 'id')
    end
  end

  describe "#h6" do
    it "calls :element with :h6 tag" do
      expect(page).to receive(:element).with(:h6, :h6_name, {id: 'id'}, [])
      page.send(:h6, :h6_name, id: 'id')
    end
  end

  describe "#image" do
    it "calls :element with :img tag" do
      expect(page).to receive(:element).with(:img, :image_name, {id: 'id'}, [])
      page.send(:image, :image_name, id: 'id')
    end
  end

  describe "#link" do
    it "calls :element with :a tag" do
      expect(page).to receive(:element).with(:a, :link_name, {id: 'id'}, [])
      page.send(:link, :link_name, id: 'id')
    end
  end

  describe "#list_item" do
    it "calls :element with :li tag" do
      expect(page).to receive(:element).with(:li, :li_name, {id: 'id'}, [])
      page.send(:list_item, :li_name, id: 'id')
    end
  end

  describe "#ordered_list" do
    it "calls :element with :ol tag" do
      expect(page).to receive(:element).with(:ol, :ol_name, {id: 'id'}, [])
      page.send(:ordered_list, :ol_name, id: 'id')
    end
  end

  describe "#paragraph" do
    it "calls :element with :p tag" do
      expect(page).to receive(:element).with(:p, :paragraph_name, {id: 'id'}, [])
      page.send(:paragraph, :paragraph_name, id: 'id')
    end
  end

  describe "#radio_button" do
    it "calls :element with :input tag" do
      expect(page).to receive(:element).with(:input, :radio_name, {id: 'id', type: 'radio'}, [])
      page.send(:radio_button, :radio_name, id: 'id')
    end
  end

  describe "#select_list" do
    it "calls :element with :select tag" do
      expect(page).to receive(:element).with(:select, :select_name, {id: 'id'}, [])
      page.send(:select_list, :select_name, id: 'id')
    end
  end

  describe "#span" do
    it "calls :element with :span tag" do
      expect(page).to receive(:element).with(:span, :span_name, {id: 'id'}, [])
      page.send(:span, :span_name, id: 'id')
    end
  end

  describe "#table" do
    it "calls :element with :table tag" do
      expect(page).to receive(:element).with(:table, :table_name, {id: 'id'}, [])
      page.send(:table, :table_name, id: 'id')
    end
  end
  
  describe "#table_cell" do
    it "calls :element with :td tag" do
      expect(page).to receive(:element).with(:td, :cell_name, {id: 'id'}, [])
      page.send(:table_cell, :cell_name, id: 'id')
    end
  end

  describe "#table_header" do
    it "calls :element with :th tag" do
      expect(page).to receive(:element).with(:th, :header_name, {id: 'id'}, [])
      page.send(:table_header, :header_name, id: 'id')
    end
  end

  describe "#table_row" do
    it "calls :element with :tr tag" do
      expect(page).to receive(:element).with(:tr, :row_name, {id: 'id'}, [])
      page.send(:table_row, :row_name, id: 'id')
    end
  end

  describe "#text_area" do
    it "calls :element with :textarea tag" do
      expect(page).to receive(:element).with(:textarea, :text_area_name, {id: 'id'}, [])
      page.send(:text_area, :text_area_name, id: 'id')
    end
  end

  describe "#text_field" do
    it "calls :element with :input tag" do
      expect(page).to receive(:element).with(:input, :text_field_name, {id: 'id'}, [])
      page.send(:text_field, :text_field_name, id: 'id')
    end
  end

  describe "#unordered_list" do
    it "calls :element with :ul tag" do
      expect(page).to receive(:element).with(:ul, :ul_name, {id: 'id'}, [])
      page.send(:unordered_list, :ul_name, id: 'id')
    end
  end
  
end
