# Pouch

Pouch is a flexible page object DSL for responsive UI testing and written with expressive scripting in mind. It currently works with watir-webdriver.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pouch'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pouch

## Usage

Include Pouch in your page object classes, which will give them access to the element definition DSL.

```ruby
class Page
  include Pouch
  link(:home, id: 'go-home')
  text_field(:search, id: 'search-term')
  button(:submit, id: 'search-submit')
end
```

Scripting is meant to be expressive, so calling the name of your element method returns the HTML object and forces you to write out your actions.

```ruby
page = Page.new browser_instance
page.home.click
page.search.value = 'search term'
page.submit.click
```

Element method definitions are flexible. You can engineer more useful definitions with block arguments.

```ruby
class Page
  include Pouch
  list_item(:phone_number, id: 'phone-num')
  list_item(:area_code, id: 'phone-num'){ |li| span.text[0..2] }
end
```

This lets your scripting be more expressive too. For example, compare these two RSpec expectations using the page object definition above:

```ruby
expect(page.phone_number[0..2]).to eq '555'
expect(page.area_code).to eq '555'
```

Pouch page objects can be created with contexts, allowing a single method call to execute two different element definitions based on that context. This is useful for responsive UI testing, when DOM elements change but the functionality is basically the same.

```ruby
class Page
  include Pouch
  link(:sign_in, id: 'desktop-login')
  link(:mobile_sign_in, id: 'mobile-login')
end
```

```ruby
# script.rb
page = Page.new @browser, context: ENV['CONTEXT']
page.sign_in.attribute_value 'id' == 'desktop-login'
```

```
$ ruby script.rb
#=> true
$ CONTEXT=mobile ruby script.rb
#=> true
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/pouch/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write tests
4. Code until all tests pass
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create a new Pull Request
