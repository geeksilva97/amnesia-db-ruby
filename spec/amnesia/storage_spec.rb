RSpec.describe Amnesia::Storage do
  let(:filename) { 'amnesia.db' }
  let(:file_content) { '' }
  subject { described_class.new(filename) }

  before do
    allow(File).to receive(:write)
    allow(File).to receive(:read)
    allow(File).to receive(:size).and_return(file_content.bytesize)
    allow(File).to receive(:readlines)
      .and_return([file_content])
    allow(File).to receive(:read)
      .with(filename, file_content.bytesize, file_content.bytesize)
      .and_return(file_content)
  end

  describe '#set' do
    before do
      subject.set('key', 'value')
    end

    it 'checks file size to calculate the offset' do
      expect(File).to have_received(:size).with('amnesia.db')
    end

    it 'writes key,value to the file' do
      expect(File).to have_received(:write).with('amnesia.db', "key,value\n", mode: 'a+')
    end
  end

  describe '#get' do
    context 'when data is indexed' do
      it 'reads from index' do
        allow(File).to receive(:read)
          .with('amnesia.db', 17, 0)
          .and_return('somekey,somevalue')

        subject.set('somekey', 'somevalue')

        expect(subject.get('somekey')).to eq('somevalue')
        expect(File).not_to have_received(:readlines)
        expect(File).to have_received(:read)
      end
    end

    context 'when data is not indexed' do
      it 'scans the database file' do
        allow(File).to receive(:readlines)
          .and_return(['anykey,anyvalue'])

        expect(subject.get('anykey')).to eq('anyvalue')
        expect(File).to have_received(:readlines)
        expect(File).not_to have_received(:read)
      end
    end
  end

  describe '#populate_index' do
    before do
      allow(File).to receive(:readlines)
        .and_return((1..2).map { |i| "key#{i},value#{i}" }.to_a)

      subject.populate_index
    end

    it 'builds structcure from database file' do
      expect(File).to have_received(:readlines).with('amnesia.db')
    end
  end
end
