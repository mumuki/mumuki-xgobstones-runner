require 'mumukit'
require 'yaml'
require 'stones-spec'

class TestRunner < Mumukit::Stub
  def run_compilation!(test_definition)
    StonesSpec::Gobstones.configure do |config|
      config.gbs_command = gobstones_command
    end

    StonesSpec::Runner.new.run!(test_definition)
  end
end
