require 'mumukit'
require 'yaml'
require 'stones-spec'

class TestRunner < Mumukit::Stub
  def gobstones_command
    @config['gobstones_command']
  end

  def run_compilation!(test_definition)
    StonesSpec::Runner.new(StonesSpec::Language::Gobstones, gobstones_command).run!(test_definition)
  end
end
