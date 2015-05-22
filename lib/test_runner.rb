require 'mumukit'
require 'yaml'

require_relative 'gobstones'

class TestRunner < Mumukit::Stub
  def gobstones_path
    @config['gobstones_command']
  end

  def run_compilation!(test_definition)
    Gobstones::Spec::Runner.new(gobstones_path).run!(test_definition)
  end
end
