module StonesSpec
  class Runner
    include StonesSpec::WithTempfile

    def run!(test_definition)
      subject = Subject.from(test_definition[:subject])
      source = test_definition[:source]
      check_head_position = test_definition[:check_head_position]
      show_initial_board = test_definition.fetch(:show_initial_board, true)

      begin
        [test_definition[:examples].map do |example_definition|
          run_example!(example_definition, check_head_position, show_initial_board, source, subject)
        end]
      rescue Gobstones::Error => e
        [e.message, e.status]
      end
    end

    private

    def run_example!(example_definition, check_head_position, show_initial_board, source, subject)
      example = Example.new(subject, example_definition)

      data = example.execution_data source
      files = {
        source: Gobstones.source_code_extension,
        initial_board: Gobstones.board_extension,
        final_board: Gobstones.board_extension
      }.map_values { |name, extension| write_tempfile(data[name], extension) }

      execution = example.execute! files

      example.result files, execution, Postcondition.from(example, check_head_position, show_initial_board)
    ensure
      files.each_value(&:unlink)
    end
  end
end
