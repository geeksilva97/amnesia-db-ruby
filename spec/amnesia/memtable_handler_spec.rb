RSpec.describe Amnesia::MemtableHandler do
  let(:segment_handler) { double('segment_handler') }
  let(:threshold) { 5 }

  subject { described_class.new(segment_handler, threshold) }

  describe '#read' do
    context 'when data is in the Memtable' do
      it 'reads data by looking at all the existing memtables' do
        allow(segment_handler).to receive(:retrieve)

        subject.write('k1', 'some_value')
        subject.write('k2', 'some_value')
        subject.write('k3', 'some_value')
        subject.write('k5', 'some_value')

        res = subject.read('k5')

        expect(res).to eq('k5,some_value')
        expect(segment_handler).to_not have_received(:retrieve)
      end
    end

    context 'when data is not in the Memtable' do
      it 'reads from segment' do
        allow(segment_handler).to receive(:retrieve)

        res = subject.read('some_key')

        expect(res).to be_nil
        expect(segment_handler).to have_received(:retrieve).with('some_key')
      end
    end
  end

  describe '#write' do
    context 'when threshold is reached' do
      it 'flushes data to the segment' do
        allow(subject).to receive(:flush)

        subject.write('key1', 'value')
        subject.write('key2', 'value')
        subject.write('key3', 'value')
        subject.write('key4', 'value')
        subject.write('key5', 'value')

        expect(subject).to have_received(:flush)
      end
    end
  end

  describe '#flush' do
    it 'flushes to the segment' do
      allow(segment_handler).to receive(:retrieve)
      allow(segment_handler).to receive(:store)

      subject.write('key1', 'value1')
      subject.write('key2', 'value2')

      result = subject.read('key2')

      expect(result).to eq('key2,value2')

      subject.flush

      result_after_flushing = subject.read('key2')

      expect(result_after_flushing).to be_nil
      expect(segment_handler).to have_received(:retrieve).with('key2')
    end
  end
end
