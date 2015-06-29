require 'mumukit'
require 'yaml'
require 'active_support/core_ext/hash'

require_relative 'with_source_concatenation'

class TestCompiler < Mumukit::Stub
  include WithSourceConcatenation

  def create_compilation!(request)
    test = YAML::load request[:test]
    test['source'] = concatenate_source request[:content], request[:extra]
    test['check_head_position'] = !!test['check_head_position']
    test.deep_symbolize_keys
  end
end
