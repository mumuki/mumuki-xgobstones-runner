require 'mumukit'
require 'yaml'

class TestCompiler < Mumukit::Stub
  def create_compilation!(test_src, extra_src, content_src)
    test = YAML::load(test_src)

    {
      source: "#{content_src}\n#{extra_src}",
      examples: {initial_board: test['initial_board'],
                 final_board: test['final_board']}
    }
  end
end
