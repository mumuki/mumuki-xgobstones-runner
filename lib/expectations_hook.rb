require 'mumukit'
require 'mumukit/inspection'
require 'yaml'

require_relative 'with_test_parser'

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
      StonesSpec::Subject.from(binding)
    end
  end

  def check_repeat_of(target)
    use(/AST\(repeat\s*#{target}/)
  end
end

class Mumukit::Inspection::PlainInspection
  include EvalExpectationsOnAST

  def expectations
    {
      'HasBinding' => lambda { |binding| subject_for(binding).ast_regexp },
      'HasForeach' => use(/AST\(foreach/),
      'HasRepeat' => check_repeat_of('.+'),
      'HasVariable' => use(/AST\(assignVarName/),
      'HasWhile' => use(/AST\(while/)
    }
  end
end

class Mumukit::Inspection::TargetedInspection
  include EvalExpectationsOnAST

  def expectations
    {
      'HasArity' => lambda { |binding| /#{subject_for(binding).ast_regexp}\s*AST\((\s*\w+){#{target}}\)/ },
      'HasRepeatOf' => check_repeat_of("AST\\(literal\\s*#{target}\\)"),
      'HasUsage' => use(/AST\((proc|func)Call\s*#{target}$/)
    }
  end
end

class Mumukit::Inspection::NegatedInspection
  def eval_in_gobstones(binding, ast)
    !@inspection.eval_in_gobstones(binding, ast)
  end
end

class ExpectationsHook < Mumukit::Hook
  include Mumukit
  include StonesSpec::WithTempfile
  include WithTestParser

  def run!(request)
    content = request[:content]
    expectations = request[:expectations]

    if content.strip.empty?
      return expectations.map { |exp| {'expectation' => exp, 'result' => false } }
    end

    ast = generate_ast! content
    all_expectations = expectations + (default_expectations_for parse_test request)

    all_expectations.map { |exp| {'expectation' => exp, 'result' => run_expectation!(exp, ast)} }
  end

  private

  def default_expectations_for(test)
    StonesSpec::Subject.from(test[:subject]).default_expectations
  end

  def run_expectation!(expectation, ast)
    Mumukit::Inspection.parse(expectation['inspection']).eval_in_gobstones(expectation['binding'], ast)
  end

  def generate_ast!(source_code)
    %x"#{gobstones_command} #{write_tempfile(source_code, 'gbs').path} --print-ast --target parse --no-print-retvals --silent"
  end

  def gobstones_command
    @config['gobstones_command']
  end
end
