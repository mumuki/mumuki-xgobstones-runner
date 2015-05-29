require 'mumukit'
require 'yaml'
require 'gobstones'

class TestRunner < Mumukit::Stub
  def program_language
    case @config['program_language']
      when 'gobstones' then Gobstones::Spec::Language::Gobstones
      when 'ruby' then Gobstones::Spec::Language::Ruby
      else
        raise "Unknown language #{@config['program_language']}"
    end
  end

  def run_compilation!(test_definition)
    Gobstones::Spec::Runner.new(program_language).run!(test_definition)
  end
end
