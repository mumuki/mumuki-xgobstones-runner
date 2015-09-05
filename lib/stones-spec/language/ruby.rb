module StonesSpec::Language
  module Ruby
    def self.source_code_extension
      'rb'
    end

    def self.run(source_file, initial_board_file, final_board_file, gobstones_command)
      "#{stones_command} #{source_file.path} #{initial_board_file.path} #{final_board_file.path}"
    end

    def self.stones_command
      'stones'
    end

    def self.parse_error_message(result)
      "<pre>#{result}</pre>"
    end

    def self.is_runtime_error?(result)
      (result.include? 'OutOfBoardError') || !!(result =~ /(red|blue|green|black) Underflow/)
    end

    def self.parse_success_output(result)
      result
    end

    def self.test_procedure(original, subject, args)
      "def main
        puts #{self.procedure_call subject, args}
      end

      #{original}"
    end

    def self.infer_subject_type_for(string)
      string.end_with?('!') ? StonesSpec::Subject::Procedure : StonesSpec::Subject::Function
    end

    def self.procedure_call(subject, args)
      "#{subject} #{args.join(', ')}"
    end

    self.singleton_class.send :alias_method, :test_function, :test_procedure
  end
end
