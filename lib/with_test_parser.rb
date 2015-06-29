require 'yaml'
require 'active_support/core_ext/hash'

module WithTestParser
  def parse_test(request)
    (YAML.load request[:test]).deep_symbolize_keys
  end
end