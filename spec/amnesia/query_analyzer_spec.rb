# frozen_string_literal: true

RSpec.describe Amnesia::QueryAnalyzer do
  let(:instruction) { 'set' }
  let(:key) { 'my:key' }
  let(:value) { 'value' }

  subject { described_class.call!(instruction, key, value) }

  describe '.call!' do
    context 'when a unknown instruction is given' do
      let(:instruction) { 'fake-instruction' }

      it 'raises an "unknown instruction" error' do
        expect { subject }.to raise_error(RuntimeError, 'unknown instruction')
      end
    end

    context 'when key contains special characters' do
      let(:key) { 'myk&y' }

      it 'raises an "malformed key" error' do
        expect { subject }.to raise_error(RuntimeError, 'malformed key')
      end
    end

    context 'when key starts with non-letter character' do
      let(:key) { '1key' }

      it 'raises an "malformed key" error' do
        expect { subject }.to raise_error(RuntimeError, 'malformed key')
      end
    end

    context 'when command is SET' do
      context 'and a value is not supplied' do
        let(:value) { nil }

        it 'raises a "set command must contain a key and a value" error' do
          expect { subject }.to raise_error(RuntimeError, 'set command must contain a key and a value')
        end
      end
    end

    context 'when params are correctly passed' do
      it 'does not raise any error' do
        expect { subject }.not_to raise_error
      end
    end
  end
end
