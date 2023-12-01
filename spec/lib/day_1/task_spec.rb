describe Day1::Task do
  subject(:task) { described_class.new(sample) }

  describe '#call1' do
    context 'when sample input' do
      let(:sample) { true }

      it 'works' do
        expect(task.call1).to eq(209)
      end
    end

    context 'when real input' do
      let(:sample) { false }

      it 'works' do
        expect(task.call1).to eq(54_561)
      end
    end
  end

  describe '#call2' do
    context 'when sample input' do
      let(:sample) { true }

      it 'works' do
        expect(task.call2).to eq(281)
      end
    end

    context 'when real input' do
      let(:sample) { false }

      it 'works' do
        expect(task.call2).to eq(54_076)
      end
    end
  end
end
