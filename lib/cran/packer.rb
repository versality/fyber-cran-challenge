require 'dcf'
require 'open-uri'
require 'cran/archiver'
require 'cran/parser'

module Cran
  Package = Struct.new(:description, :package, :title,
                       :date, :repository, :license,
                       :packaged_at, :published_at, :version,
                       :url, :maintainers)

  class Packer
    def initialize(repo_url, package_meta)
      @package_url  = construct_url(repo_url, package_meta)
    end

    def build
      download
    end

    private
    def download
      open(@package_url) do |file|
        return unarchive(file)
      end
    end

    def unarchive(file)
      archive = Archive.new(file)
      archive.content do |files|
        return get_description(files)
      end
    end

    def get_description(files)
      files.each do |file|
        if file.full_name.include? '/DESCRIPTION'
          description_content = file.read
          return index_package(description_content)
        end
      end
    end

    def index_package(desc)
      package_meta = Dcf.parse(desc).first

      package              = ::Cran::Package.new
      package.description  = package_meta['Description']
      package.package      = package_meta['Package']
      package.title        = package_meta['Title']
      package.date         = package_meta['Date']
      package.repository   = package_meta['Repository']
      package.license      = package_meta['License']
      package.packaged_at  = package_meta['Packaged']
      package.published_at = package_meta['Date/Publication']
      package.version      = package_meta['Version']
      package.maintainers  = ::Cran::Parser.parse_maintainers(package_meta)

      package
    end

    def construct_url(repo_url, package_meta)
      "#{repo_url}/src/contrib/#{package_meta['Package']}_#{package_meta['Version']}.tar.gz"
    end
  end
end