RSpec.describe Amnesia::Support::AVL do
  subject { described_class.new }

  describe '#insert' do
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
  end
end
