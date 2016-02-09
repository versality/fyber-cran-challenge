require 'rubygems/package'
require 'zlib'

module Cran
  class Archive
    def initialize(file)
      @file = file
    end

    def content
      tar_extract = Gem::Package::TarReader.new(Zlib::GzipReader.open(@file))
      tar_extract.rewind

      yield(tar_extract)

      tar_extract.close
    end
  end
end
