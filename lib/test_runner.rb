require 'mumukit'
require 'yaml'
require 'stones-spec'

class TestRunner < Mumukit::Stub
  def run_compilation!(test_definition)
    StonesSpec::Runner.new(StonesSpec::Language::Gobstones).run!(test_definition)
  end
end
