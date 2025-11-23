require 'validators'

RSpec.describe Validators do
  describe '.string' do
    context 'with string' do
      let(:value) { 'some string' }

      it 'returns true' do
        expect(described_class.string(value)).to eq true
      end
    end

    context 'without string' do
      let(:value) { 123 }

      it 'returns false' do
        expect(described_class.string(value)).to eq false
      end
    end
  end

  describe '.array_of_strings' do
    context 'when valid' do
      let(:value) { %w[some string here] }

      it 'returns true' do
        expect(described_class.array_of_strings(value)).to eq true
      end
    end

    context 'when invalid' do
      let(:value) { 'string' }

      it 'returns false' do
        expect(described_class.array_of_strings(value)).to eq false
      end
    end
  end

  # etc.
  # ...
end
