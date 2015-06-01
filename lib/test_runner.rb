require 'mumukit'
require 'yaml'
require 'gobstones'

class TestRunner < Mumukit::Stub
  def run_compilation!(test_definition)
    result =  Gobstones::Spec::Runner.new(Gobstones::Spec::Language::Gobstones).run!(test_definition)

    if result[1] == :failed
      result[0] = "<pre>#{result[0]}</pre>"
    end

    result
  end
end
