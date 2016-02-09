require 'spec_helper'

RSpec.describe Cran::Indexer, :vcr do
  describe '#get_packages' do
    it 'should return processed packages' do
      package_list = [{
                          'Package' => 'A3',
                          'Version' => '1.0.0',
                          'Depends' => 'R (>= 2.15.0), xtable, pbapply',
                          'Suggests' => 'randomForest, e1071',
                          'License' => 'GPL (>= 2)',
                          'NeedsCompilation' => 'no'
                      }]

      expect_any_instance_of(Cran::Indexer).to receive(:fetch_packages_list).and_return(package_list)
      expect(subject.get_packages('https://cran.r-project.org')).to_not be_nil
    end
  end
end