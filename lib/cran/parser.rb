require 'net/http'
require 'dcf'
require 'open-uri'
require 'rubygems/package'
require 'zlib'

module Cran
  Maintainer = Struct.new(:name, :email)

  class Parser
    class << self
      def parse_maintainers(desc)
        name  = desc['Maintainer']
        email = name[/<(.*?)>/m, 1]

        if email
          name = name.gsub("<#{email}>", '')
          name.strip!
        end

        Maintainer.new(name, email)
      end
    end
  end
end