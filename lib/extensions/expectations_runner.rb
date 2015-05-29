require 'mumukit'
require 'mumukit/inspection'

class Mumukit::Inspection::PlainInspection
  def to_gobstones_inspection
    Falsy.new
  end
end

class Mumukit::Inspection::TargetedInspection
  def to_gobstones_inspection
    if type == 'HasUsage'
      Gobstones::Expectations::HasProcedureUsage.new(target)
    else
      Falsy.new
    end
  end
end

class Mumukit::Inspection::NegatedInspection
  def to_gobstones_inspection
    Negated.new(@inspection.to_gobstones_inspection)
  end
end

class Negated
  def initialize(base)
    @base = base
  end
  def value_for(ast)
    !@base.value_for(ast)
  end
end

class Falsy
  def value_for(ast)
    false
  end
end
class ExpectationsRunner
  include Mumukit

  def run_expectations!(expectations, content)
    runner = Gobstones::Expectations::ExpectationsRunner.new(Gobstones::Spec::Language::Gobstones.gobstones_command, content)
    parsed_inspections = expectations.map { |e| Mumukit::Inspection.parse(e['inspection']).to_gobstones_inspection }
    runner.run!(parsed_inspections)
  end

end
