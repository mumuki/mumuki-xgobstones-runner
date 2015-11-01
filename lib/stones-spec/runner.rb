module StonesSpec
  class Runner
    include StonesSpec::WithTempfile

    attr_reader :language, :gobstones_command

    def initialize(language, gobstones_command)
      @language = language
      @gobstones_command = gobstones_command
    end

    def run!(test_definition)
      subject = Subject.from(test_definition[:subject], language)
      source = test_definition[:source]
      check_head_position = test_definition[:check_head_position]
      show_initial_board = test_definition.fetch(:show_initial_board, true)

      begin
        [test_definition[:examples].map do |example_definition|
          run_example!(example_definition, check_head_position, show_initial_board, source, subject)
        end]
      rescue GobstonesSyntaxError => e
        [e.message, :errored]
      end
    end

    private

    def test_program(source, subject)
      language.test_program(source, subject)
    end

    def run_example!(example_definition, check_head_position, show_initial_board, source, subject)
      example = StonesSpec::Example.new(language, subject, example_definition, gobstones_command)
      example.start!(
          source,
          Precondition.from_example(example),
          Postcondition.from(example, check_head_position, show_initial_board))
      example.result
    ensure
      example.stop!
    end
  end
end
