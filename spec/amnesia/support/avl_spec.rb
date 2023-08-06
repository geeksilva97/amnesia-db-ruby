RSpec.describe Amnesia::Support::AVL do
  subject { described_class.new }

  describe '#insert' do
    it 'increments the size' do
      subject.insert(10)
      subject.insert(11)

      expect(subject.size).to eq(2)
    end

    context 'when the tree is empty' do
      it 'add the node as the root of the tree' do
        subject.insert(10)

        expect(subject.root.key).to eq(10)
      end
    end

    context 'when the tree already contains nodes' do
      context 'and the insertion makes it unbalanced' do
        it 'adds nodes and balances the tree with single rotations to left' do
          subject.insert(19)
          subject.insert(20)
          subject.insert(21)

          expect(subject.root.key).to eq(20)
          expect(subject.root.left.key).to eq(19)
          expect(subject.root.right.key).to eq(21)
        end

        it 'adds nodes and balances the tree with single rotations to right' do
          subject.insert(21)
          subject.insert(20)
          subject.insert(19)

          expect(subject.root.key).to eq(20)
          expect(subject.root.left.key).to eq(19)
          expect(subject.root.right.key).to eq(21)
        end

        it 'adds nodes and balances the tree with double rotations to left' do
          subject.insert(19)
          subject.insert(25)
          subject.insert(21)

          expect(subject.root.key).to eq(21)
          expect(subject.root.left.key).to eq(19)
          expect(subject.root.right.key).to eq(25)
        end

        it 'adds nodes and balances the tree with double rotations to left' do
          subject.insert(25)
          subject.insert(19)
          subject.insert(21)

          expect(subject.root.key).to eq(21)
          expect(subject.root.left.key).to eq(19)
          expect(subject.root.right.key).to eq(25)
        end
      end
    end

    context 'when the inserted key already exists in the tree' do
      it 'updates the node value' do
        subject.insert(10, 'a')
        subject.insert(11, 'b')
        subject.insert(12, 'c')

        expect(subject.root.key).to eq(11)
        expect(subject.root.right.key).to eq(12)
        expect(subject.root.right.value).to eq('c')

        subject.insert(12, 'd')

        expect(subject.root.key).to eq(11)
        expect(subject.root.right.key).to eq(12)
        expect(subject.root.right.value).to eq('d')
      end

      it 'does not increment the size' do
        subject.insert(10, 'a')
        subject.insert(10, 'b')
        subject.insert(10, 'c')

        expect(subject.size).to eq(1)
      end
    end
  end

  describe '#traverse' do
    it 'executes the given block for each node' do
      subject.insert(10, 'abc')
      subject.insert(11, 'def')
      subject.insert(12, 'ghi')

      expect do |block|
        subject.traverse(&block)
      end.to yield_successive_args({ key: 10, value: 'abc' }, { key: 11, value: 'def' },
                                   { key: 12, value: 'ghi' })
    end
  end

  describe '#find' do
    context 'when the key exists in the tree' do
      it 'returns the found node' do
        subject.insert(10, 'abc')

        found = subject.find(10)

        expect(found.key).to eq(10)
      end
    end

    context 'when the key does not exist in the tree' do
      it 'returns nil' do
        subject.insert(10, 'abc')

        found = subject.find(1)

        expect(found).to be_nil
      end
    end
  end
end
