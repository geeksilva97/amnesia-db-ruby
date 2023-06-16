RSpec.describe Amnesia::QueryRunner do
  let(:segment_handler) { instance_double(Amnesia::SegmentHandler) }
  let(:instruction) { ['get', 'somekey', nil] }

  subject { described_class.new(segment_handler) }

  describe '#run' do
    before do
      allow(segment_handler).to receive(:retrieve)
      allow(segment_handler).to receive(:store)
      allow(segment_handler).to receive(:delete)

      subject.run(*(instruction + [nil]).take(3))
    end

    context 'when instruction is get' do
      it 'retrieves value from segment handler' do
        expect(segment_handler).to have_received(:retrieve)
          .with('somekey')
      end
    end

    context 'when instruction is set' do
      let(:instruction) { %w[set somekey somevalue] }

      it 'stores value into a segment' do
        expect(segment_handler).to have_received(:store)
          .with({ 'somekey' => 'somevalue' })
      end
    end

    context 'when instruction is delete' do
      let(:instruction) { %w[delete somekey] }

      it 'stores value into a segment' do
        expect(segment_handler).to have_received(:delete)
          .with('somekey')
      end
    end
  end
end
