module StonesSpec
  class Runner
    include StonesSpec::WithTempfile

    attr_reader :language

    def initialize(language)
      @language = language
    end

    def run!(test_definition)
      subject = Subject.from(test_definition[:subject])
      results = test_definition[:examples].map do |example_definition|
        example_definition[:check_head_position] = test_definition[:check_head_position]
        run_example!(example_definition, test_definition[:source], subject)
      end
      aggregate_results(results)
    end

    private

    def test_program(source, subject)
      language.test_program(source, subject)
    end

    def run_example!(example_definition, source, subject)
      result, status = start_example(source, example_definition, subject)
      post_process result, status
    end

    def aggregate_results(results)
      [results.map { |it| it[0] }.join("\n<hr>\n"), results.all? { |it| it[1] == :passed } ? :passed : :failed]
    end

    def post_process(result, status)
      if status == :passed
        @example.result
      else
        [@example.parse_error_message(result), status]
      end
    ensure
      @example.stop!
    end

    def start_example(source, example_definition, subject)
      @example = StonesSpec::Example.new(example_definition[:check_head_position], language, subject)
      @example.start!(source, example_definition[:initial_board], example_definition[:final_board], example_definition[:arguments])
    end
  end
end
