require 'mumukit'
require 'yaml'

require_relative 'with_source_concatenation'

class TestCompiler < Mumukit::Stub
  include WithSourceConcatenation

  def create_compilation!(test_src, extra_src, content_src)
    test = YAML::load(test_src)
    {
      source: concatenate_source(content_src, extra_src),
      subject: test['subject'],
      check_head_position: !!test['check_head_position'],
      examples: test['examples'].map { |it| {initial_board: it['initial_board'], final_board: it['final_board']} }
    }
  end
end
