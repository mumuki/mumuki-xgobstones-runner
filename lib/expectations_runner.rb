require 'mumukit'
require 'mumukit/inspection'
require 'stones-spec'

require_relative 'subject_extensions'

module EvalExpectationsOnAST
  def eval_in_gobstones(binding, ast)
    pattern_generator = expectations[type]

    if pattern_generator
      !!(ast =~ pattern_generator[binding])
    else
      true
    end
  end

  def use(regexp)
    lambda { |_| regexp }
  end

  def subject_for(binding)
    if binding == 'program'
      StonesSpec::Subject::Program
    else
      StonesSpec::Subject.from(binding, StonesSpec::Language::Gobstones)
    end
  end
end

class Mumukit::Inspection::PlainInspection
  include EvalExpectationsOnAST

  def expectations
    {
      'HasWhile' => use(/AST\(while/),
      'HasBinding' => lambda { |binding| subject_for(binding).ast_regexp }
    }
  end
end

class Mumukit::Inspection::TargetedInspection
  include EvalExpectationsOnAST

  def expectations
    {
      'HasUsage' => use(
/AST\(procCall
\s*#{target}/),

      'HasRepeatOf' => use(
/AST\(repeat
\s*AST\(literal
\s*#{target}\)/),

      'HasArity' => lambda { |binding| /#{subject_for(binding).ast_regexp}\s*AST\((\s*\w+){#{target}}\)/ }
    }
  end
end

class Mumukit::Inspection::NegatedInspection
  def eval_in_gobstones(binding, ast)
    !@inspection.eval_in_gobstones(binding, ast)
  end
end

class ExpectationsRunner
  include Mumukit
  include StonesSpec::WithTempfile

  def run_expectations!(request)
    if request[:content].strip.empty?
      return request[:expectations].map { |exp| {'expectation' => exp, 'result' => false } }
    end

    ast = generate_ast! request[:content]
    request[:expectations].map { |exp| {'expectation' => exp, 'result' => run_expectation!(exp, ast)} }
  end

  def run_expectation!(expectation, ast)
    Mumukit::Inspection.parse(expectation['inspection']).eval_in_gobstones(expectation['binding'], ast)
  end

  def generate_ast!(source_code)
    %x"#{gobstones_command} #{write_tempfile(source_code, 'gbs').path} --print-ast --target parse --no-print-retvals --silent"
  end

  def gobstones_command
    StonesSpec::Language::Gobstones.gobstones_command
  end
end
