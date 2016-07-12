require 'mumukit'

Mumukit.runner_name = 'gobstones'
Mumukit.configure do |config|
  config.structured = true
  config.content_type = 'html'
end

require 'active_support/all'
require_relative './stones_spec'
require_relative './test_hook'
require_relative './metadata_hook'
require_relative './expectations_hook'
