describe Day18::Task do
  subject(:task) { described_class.new(sample) }

  describe '#call1' do
    context 'when sample input' do
      let(:sample) { true }

      it 'works' do
        expect(task.call1).to eq(62)
      end
    end

    context 'when real input' do
      let(:sample) { false }

      it 'works' do
        expect(task.call1).to eq(50_465)
      end
    end
  end

  describe '#call2' do
    context 'when sample input' do
      let(:sample) { true }

      it 'works' do
        expect(task.call2).to eq(952408144115)
      end
    end

    context 'when real input' do
      let(:sample) { false }

      it 'works' do
        expect(task.call2).to eq(82712746433310)
      end
    end
  end
end
