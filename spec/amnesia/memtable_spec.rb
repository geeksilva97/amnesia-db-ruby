RSpec.describe Amnesia::Memtable do
  let(:avl) { Amnesia::Support::AVL.new }
  let(:segment_handler) { double }

  subject { described_class.new(avl) }

  describe '#read' do
    it 'reads from store structure' do
      allow(avl).to receive(:find)

      subject.read('some_key')

      expect(avl).to have_received(:find).with('some_key')
    end
  end

  describe '#write' do
    it 'writes to store structure' do
      allow(avl).to receive(:insert)

      subject.write('some_key', 'some_value')

      expect(avl).to have_received(:insert).with('some_key', 'some_value')
    end
  end

  describe '#flush' do
    it 'store all nodes to the segment' do
      avl.insert(10, 'hello')
      avl.insert(11, 'world')

      allow(segment_handler).to receive(:store)

      subject.flush(segment_handler)

      expect(segment_handler).to have_received(:store).exactly(2)
      expect(segment_handler).to have_received(:store).once.with({ key: 10, value: 'hello' })
      expect(segment_handler).to have_received(:store).once.with({ key: 11, value: 'world' })
    end
  end
end
