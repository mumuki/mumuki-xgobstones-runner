require 'mumukit'

class TestRunner
  def gobstones_path
    @config['gobstones_command']
  end

  def run_test_command(file)
    "#{gobstones_path} #{file.path}"
  end
end