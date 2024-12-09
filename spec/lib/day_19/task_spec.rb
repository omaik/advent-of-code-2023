describe Day19::Task do
  subject(:task) { described_class.new(sample) }

  describe '#call1' do
    context 'when sample input' do
      let(:sample) { true }

      it 'works' do
        expect(task.call1).to eq(19_114)
      end
    end

    context 'when real input' do
      let(:sample) { false }

      it 'works' do
        expect(task.call1).to eq(332_145)
      end
    end
  end

  describe '#call2' do
    context 'when sample input' do
      let(:sample) { true }

      it 'works' do
        expect(task.call2).to eq(167_409_079_868_000)
      end
    end

    context 'when real input' do
      let(:sample) { false }

      it 'works' do
        expect(task.call2).to eq(136_661_579_897_555)
      end
    end
  end
end
