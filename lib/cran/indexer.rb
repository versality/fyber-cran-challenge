require 'dcf'
require 'cran/packer'

module Cran
  class Indexer
    def get_packages(repo_url)
      packages_list_meta = fetch_packages_list(repo_url)

      packages = []

      # Artificial limit for the challenge
      packages_list_meta.first(50).each do |package_meta|
        cran_package = Cran::Packer.new(repo_url, package_meta)
        packages << cran_package.build
      end

      packages
    end

    private
    def fetch_packages_list(repo_url)
      url = "#{repo_url}/src/contrib/PACKAGES"
      uri = URI(url)
      res = Net::HTTP.get_response(uri)
      ::Dcf.parse(res.body)
    end
  end
end