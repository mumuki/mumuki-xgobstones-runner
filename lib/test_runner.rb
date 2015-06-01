require 'mumukit'
require 'yaml'
require 'gobstones'

class TestRunner < Mumukit::Stub
  def run_compilation!(test_definition)
    Gobstones::Spec::Runner.new(Gobstones::Spec::Language::Gobstones).run!(test_definition)
  end
end
