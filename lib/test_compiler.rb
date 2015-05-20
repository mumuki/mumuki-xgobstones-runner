require 'mumukit'
require 'yaml'

class TestCompiler
  def compile(test_src, extra_src, content_src)
    test = YAML::load(test_src)

    {
      :source => "#{content_src}\n#{extra_src}",
      :initial_board => test['initial_board'],
      :final_board => test['final_board'],
    }.to_yaml
  end
end