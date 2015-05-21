require 'mumukit'
require 'yaml'

require_relative 'gobstones'

class ErrorMessageParser
  def parse(result)
    remove_line_specification = lambda { |x| x.drop(3) }

    remove_traceback = lambda { |x|
      x.take_while { |str| not str.start_with? 'Traceback' }
    }

    remove_boom_line_specification = lambda { |x|
      x.take_while { |str| not str.strip.start_with? 'En:' }
    }

    remove_boom_line_specification[
        remove_traceback[
            remove_line_specification[
                result.lines
            ]
        ]
    ].join.strip
  end
end

class TestRunner
  def gobstones_path
    @config['gobstones_command']
  end

  def post_process_file(file, result, status)
    begin
      if status == :passed
        ["<div>#{@html_output_file.read}</div>", compute_test_status]
      else
        [get_error_message(result), status]
      end
    ensure
      [@html_output_file, @actual_final_board_file].each { |it| it.close }
      [@html_output_file, @actual_final_board_file, @source_file, @initial_board_file].each { |it| it.unlink }
    end
  end

  def run_test_command(file)
    test_definition = YAML::load_file file.path

    @expected_final_board = Gobstones::GbbParser.new.from_string test_definition[:final_board]

    @html_output_file = Tempfile.new %w(gobstones.output .html)
    @actual_final_board_file = Tempfile.new %w(gobstones.output .gbb)
    @source_file = create_temp_file test_definition, :source, 'gbs'
    @initial_board_file = create_temp_file test_definition, :initial_board, 'gbb'

    "#{run_on_gobstones @source_file, @initial_board_file, @actual_final_board_file} 2>&1 &&" +
        "#{run_on_gobstones @source_file, @initial_board_file, @html_output_file}"
  end

  private

  def run_on_gobstones(source_file, initial_board_file, final_board_file)
    "#{gobstones_path} #{source_file.path} --from #{initial_board_file.path} --to #{final_board_file.path}"
  end

  def create_temp_file(test_definition, attribute, extension)
    file = Tempfile.new %W(gobstones.#{attribute} .#{extension})
    file.write test_definition[attribute]
    file.close
    file
  end

  def compute_test_status
    actual = Gobstones::GbbParser.new.from_string(@actual_final_board_file.read)
    actual == @expected_final_board ? :passed : :failed
  end

  def get_error_message(result)
    ErrorMessageParser.new.parse(result)
  end
end