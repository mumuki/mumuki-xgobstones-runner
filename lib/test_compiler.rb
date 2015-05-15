require 'mumukit'
require 'yaml'

class TestCompiler
  def create_compilation_file!(test, extra, content)
    file = create_tempfile
    file.write compile(test, extra, content).to_yaml
    file.close
    file
  end

  def compile(test_src, extra_src, content_src)
    {
      :source => "#{content_src}\n#{extra_src}",
      :initial_board => test_src
    }
  end
end