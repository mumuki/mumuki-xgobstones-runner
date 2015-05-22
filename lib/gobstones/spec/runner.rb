require 'mumukit'

module Gobstones::Spec
  class Runner
    include Mumukit::WithCommandLine

    attr_reader :gobstones_path

    def initialize(gobstones_path)
      @gobstones_path = gobstones_path
    end

    def run!(test_definition)
      results = [test_definition[:examples]].map do |example_definition|
        command = start_example(test_definition[:source],
                                example_definition[:initial_board],
                                example_definition[:final_board])
        result, status = run_command command
        post_process result, status
      end
      [results.map { |it| it[0] }.join("\n"), results.all? { |it| it[1] == :passed } ? :passed : :failed]
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

    def start_example(source, initial, final)
      @example = Gobstones::Spec::Example.new(gobstones_path)
      @example.start!(source, initial, final)
    end
  end
end
