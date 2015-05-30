require 'mumukit'
require 'mumukit/inspection'
require 'gobstones'


class Mumukit::Inspection::PlainInspection
  def eval_in_gobstones(ast)
    false
  end
end

class Mumukit::Inspection::TargetedInspection
  def eval_in_gobstones(ast)
    if type == 'HasUsage'
      !!(ast =~ /AST\(procCall\s*#{target}/)
    else
      false
    end
  end
end

class Mumukit::Inspection::NegatedInspection
  def eval_in_gobstones(ast)
    !@inspection.eval_in_gobstones(ast)
  end
end

class ExpectationsRunner
  include Mumukit
  include Gobstones::WithTempfile

  def run_expectations!(expectations, content)
    ast = generate_ast!(content)

    expectations.map { |exp| {'expectation' => exp, 'result' => run_expectation!(exp, ast)} }
  end

  def run_expectation!(expectation, ast)
    Mumukit::Inspection.parse(expectation['inspection']).eval_in_gobstones(ast)
  end

  def generate_ast!(source_code)
    %x"#{gobstones_command} #{write_tempfile(source_code, 'gbs').path} --print-ast --no-print-board --no-print-retvals"
  end

  def gobstones_command
    Gobstones::Spec::Language::Gobstones.gobstones_command
  end
end
