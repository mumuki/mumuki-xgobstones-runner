class GobstonesExpectationsHook < Mumukit::Templates::MulangExpectationsHook
  include_smells true

  def language
    'Gobstones'
  end

  def default_smell_exceptions
    %w(UsesCut UsesFail UsesUnificationOperator HasRedundantReduction HasRedundantParameter)
  end

  def default_smell_exceptions
    LOGIC_SMELLS + FUNCTIONAL_SMELLS + OBJECT_ORIENTED_SMELLS
  end
end
