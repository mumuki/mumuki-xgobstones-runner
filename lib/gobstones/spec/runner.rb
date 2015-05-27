module Gobstones::Spec
  class Runner
    include Gobstones::WithTempfile

    attr_reader :language

    def initialize(language)
      @language = language
    end

    def run!(test_definition)
      source_file = write_tempfile test_definition[:source], language.source_code_extension
      results = test_definition[:examples].map do |example_definition|
        example_definition[:check_head_position] = test_definition[:check_head_position]
        run_example!(example_definition, source_file)
      end
      aggregate_results(results)
    ensure
      source_file.unlink
    end

    private

    def run_example!(example_definition, source_file)
      result, status = start_example(source_file, example_definition)
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

    def start_example(source, example_definition)
      @example = Gobstones::Spec::Example.new(example_definition[:check_head_position], language)
      @example.start!(source, example_definition[:initial_board], example_definition[:final_board])
    end
  end
end
