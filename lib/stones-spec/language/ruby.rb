module StonesSpec::Language
  module Ruby
    def self.source_code_extension
      'rb'
    end

    def self.run(source_file, initial_board_file, final_board_file)
      "#{stones_command} #{source_file.path} #{initial_board_file.path} #{final_board_file.path}"
    end

    def self.stones_command
      'stones'
    end

    def self.parse_error_message(result)
      "<pre>#{result}</pre>"
    end

    def self.test_program(original, subject, args)
      "def main
        #{subject} #{(args||[]).join(',')}
      end

      #{original}"
    end
  end
end
