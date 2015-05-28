module Gobstones::Spec::Language
  module Ruby
    def self.source_code_extension
      'rb'
    end

    def self.run(source_file, initial_board_file, final_board_file)
      "#{gobgems_command} #{source_file.path} #{initial_board_file.path} #{final_board_file.path}"
    end

    def self.gobgems_command
      'gobgems'
    end
  end
end
