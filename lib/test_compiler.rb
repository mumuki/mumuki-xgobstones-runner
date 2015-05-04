require 'mumukit'

class TestCompiler
  def compile(test_src, extra_src, content_src)
    <<EOF
#{content_src}
#{extra_src}
EOF
  end
end