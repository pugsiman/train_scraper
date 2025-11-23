require './lib/scraper'

RSpec.describe Scraper::Thetrainline do
  describe '.find' do
    # NOTE: this spec simply reuses the existing mock in the actual class.
    # normally the best way to go about it (imo) would be to record the external response in a YAML file
    # with something like the VCR gem
    it 'returns results array' do
      results = described_class.find('test', 'test2', DateTime.now)
      expect(results.sample).to be_a Hash
    end
  end
end
