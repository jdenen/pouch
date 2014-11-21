$LOAD_PATH.unshift(File.expand_path '../../lib', __FILE__)

require 'pouch'
require 'rspec'

RSpec.configure do |config|
  config.order = 'default'
end
