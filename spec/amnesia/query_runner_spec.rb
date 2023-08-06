RSpec.describe Amnesia::QueryRunner do
  let(:memtable_handler) { instance_double(Amnesia::MemtableHandler) }
  let(:segment_handler) { instance_double(Amnesia::SegmentHandler) }
  let(:instruction) { ['get', 'somekey', nil] }

  subject { described_class.new(memtable_handler) }

  describe '#run' do
    before do
      allow(memtable_handler).to receive(:read)
      allow(memtable_handler).to receive(:write)
      allow(memtable_handler).to receive(:delete)

      subject.run(*(instruction + [nil]).take(3))
    end

    context 'when instruction is get' do
      it 'retrieves value from segment handler' do
        expect(memtable_handler).to have_received(:read)
          .with('somekey')
      end
    end

    context 'when instruction is set' do
      let(:instruction) { %w[set somekey somevalue] }

      it 'stores value into a segment' do
        expect(memtable_handler).to have_received(:write)
          .with('somekey', 'somevalue')
      end
    end

    context 'when instruction is delete' do
      let(:instruction) { %w[delete somekey] }

      it 'stores value into a segment' do
        expect(memtable_handler).to have_received(:delete)
          .with('somekey')
      end
    end
  end
end
