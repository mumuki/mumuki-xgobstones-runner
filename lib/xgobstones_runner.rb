require 'mumukit'

I18n.load_translations_path File.join(__dir__, 'locales', '*.yml')

Mumukit.runner_name = 'gobstones'
Mumukit.configure do |config|
  config.structured = true
  config.content_type = 'html'
end

require 'active_support/all'

require_relative './string'
require_relative './validation_hook'
require_relative './stones_spec'
require_relative './test_hook'
require_relative './metadata_hook'
require_relative './expectations_hook'
