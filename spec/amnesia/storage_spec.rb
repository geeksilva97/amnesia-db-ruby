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

    it 'writes key,value to the file' do
      expect(File).to have_received(:write).with('amnesia.db', "key,value\n", mode: 'a+')
    end
  end

  describe '#delete' do
    before do
      subject.delete('key')
    end

    it 'writes a tombstone entry to the file' do
      expect(File).to have_received(:write).with('amnesia.db', "key,\n", mode: 'a+')
    end
  end

  describe '#get' do
    context 'when data is indexed' do
      it 'reads using the given index entry' do
        allow(File).to receive(:read)
          .with('amnesia.db', 17, 0)
          .and_return('somekey,somevalue')

        subject.set('somekey', 'somevalue')

        result = subject.get('somekey', index_entry: [0, 17])

        expect(result).to eq('somevalue')
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

    context 'when returned data is a tombstone' do
      it 'returns (nil)' do
        allow(File).to receive(:readlines)
          .and_return(['tombstone,'])

        result = subject.get('tombstone')

        expect(result).to eq('(nil)')
      end
    end

    context 'when the searched key does not exist' do
      it 'returns (nil)' do
        allow(File).to receive(:readlines)
          .and_return(['tombostone,'])

        result = subject.get('hello')

        expect(result).to eq('(nil)')
      end
    end
  end
end
