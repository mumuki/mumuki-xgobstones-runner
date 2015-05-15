require 'mumukit'
require 'yaml'

class TestCompiler
  def compile(test_src, extra_src, content_src)
    {
      :source => "#{content_src}\n#{extra_src}",
      :initial_board => test_src
    }.to_yaml
  end
end