require 'simplecov'
require 'rspec'
SimpleCov.start

RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.formatter = :documentation
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.order = "random"
end
