require 'mumukit'
require 'yaml'
require 'active_support/core_ext/hash'

require_relative 'with_source_concatenation'

class TestCompiler < Mumukit::Stub
  include WithSourceConcatenation

  def create_compilation!(test_src, extra_src, content_src)
    test = YAML::load test_src
    test['source'] = concatenate_source(content_src, extra_src)
    test['check_head_position'] = !!test['check_head_position']
    test.deep_symbolize_keys
  end
end
