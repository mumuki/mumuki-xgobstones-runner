module StonesSpec::Language
  module Gobstones

    def self.source_code_extension
      'gbs'
    end

    def self.run(source_file, initial_board_file, final_board_file)
      "#{gobstones_command} #{source_file.path} --from #{initial_board_file.path} --to #{final_board_file.path}"
    end

    def self.gobstones_command
      'python .heroku/vendor/pygobstones/language/vgbs/gbs.py'
    end
  end
end
