require 'field'
require 'mechanize'

RSpec.describe Field do
  let(:page_mock) { Mechanize::Page.new(URI('http://example.com/mock.html'), nil, File.read('spec/page_mock.html'), 200, Mechanize.new) }
  subject { described_class.new(:some_field, :string, ->(_page) { ' mock ' }) }

  describe '#parse!' do
    it 'parses HTML element into the result attribute' do
      expect(subject.parse!(page_mock)).to eq ' mock '
    end
  end

  describe 'format!' do
    it 'formats the parse result' do
      subject.parse!(page_mock)
      expect { subject.format! }.to(change { subject.result }.to('mock'))
    end
  end

  describe 'validate!' do
    context 'when validator passes' do
      before { subject.parse!(page_mock) }

      it 'validates the parse result' do
        expect { subject.validate! }.not_to raise_error
      end
    end

    context 'when validator does not pass' do
      it 'raises an error' do
        expect { subject.validate! }.to raise_error(described_class::InvalidResultError)
      end
    end
  end
end
