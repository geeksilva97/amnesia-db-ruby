RSpec.describe Amnesia::QueryParser do
  let(:command) { 'set key value' }
  subject { described_class.call(command) }

  describe '.call' do
    context 'when query contains less than 2 tokens' do
      let(:command) { 'get' }

      it 'raises an "Unable to parse command" error' do
        expect { subject }.to raise_error(RuntimeError, 'Unable to parse command')
      end
    end

    context 'when query contains more than 3 tokens' do
      let(:command) { 'set some specific key' }

      it 'raises an "Unable to parse command" error' do
        expect { subject }.to raise_error(RuntimeError, 'Unable to parse command')
      end
    end

    # TODO: Use RSpec shared examples
    context 'when query contains 2 tokens' do
      let(:command) { 'get somekey' }

      it 'returns an array with the tokens' do
        expect(subject).to eq(%w[get somekey])
      end
    end

    context 'when query contains 3 tokens' do
      it 'returns an array with the tokens' do
        expect(subject).to eq(%w[set key value])
      end
    end
  end
end
