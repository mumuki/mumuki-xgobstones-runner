require 'mumukit'
require 'yaml'

class TestCompiler < Mumukit::Stub
  def create_compilation!(test_src, extra_src, content_src)
    test = YAML::load(test_src)
    {
      source: "#{content_src}\n#{extra_src}",
      check_head_position: test['check_head_position'],
      examples: test['examples'].map { |it| {initial_board: it['initial_board'], final_board: it['final_board']} }
    }
  end
end
