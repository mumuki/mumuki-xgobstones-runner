require 'mumukit'
require 'yaml'
require 'recursive-open-struct'

require_relative 'with_source_concatenation'

class TestCompiler < Mumukit::Stub
  include WithSourceConcatenation

  def create_compilation!(test_src, extra_src, content_src)
    test = RecursiveOpenStruct.new (YAML::load test_src), :recurse_over_arrays => true
    test.source = concatenate_source(content_src, extra_src)
    test.check_head_position = !!test.check_head_position
    test.to_h
  end
end
