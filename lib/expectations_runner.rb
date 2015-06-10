require 'mumukit'
require 'mumukit/inspection'
require 'stones-spec'

class Mumukit::Inspection::PlainInspection
  def eval_in_gobstones(ast)
    if type == 'HasWhile'
      !!(ast =~ /AST\(while/)
    else
      false
    end
  end
end

class Mumukit::Inspection::TargetedInspection
  def eval_in_gobstones(ast)
    if type == 'HasUsage'
      !!(ast =~ /AST\(procCall\s*#{target}/)
    elsif type == 'HasRepeatOf'
      !!(ast =~ /AST\(repeat\s*AST\(literal\s*#{target}\)/)
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
  include StonesSpec::WithTempfile

  def run_expectations!(expectations, content, extra='')
    ast = generate_ast!(content)
    expectations.map { |exp| {'expectation' => exp, 'result' => run_expectation!(exp, ast)} }
  end

  def run_expectation!(expectation, ast)
    Mumukit::Inspection.parse(expectation['inspection']).eval_in_gobstones(ast)
  end

  def generate_ast!(source_code)
    remove_compilation_steps %x"#{gobstones_command} #{write_tempfile(source_code, 'gbs').path} --print-ast --target parse --no-print-retvals"
  end

  def gobstones_command
    StonesSpec::Language::Gobstones.gobstones_command
  end

  private

  def remove_compilation_steps(output)
    output.lines.drop(2).join
  end
end
