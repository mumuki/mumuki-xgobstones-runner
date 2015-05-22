require 'tempfile'

module Gobstones
  module WithTempfile

    def write_tempfile(content, extension)
      file = Tempfile.new %W(gobstones. .#{extension})
      file.write content
      file.close
      file
    end
  end
end
