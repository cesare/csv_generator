describe CsvGenerator do
  describe '#<<' do
    let(:io) { StringIO.new }
    let(:csv) { CsvGenerator.new(io) }

    context 'given string values' do
      specify do
        csv << ['test', '0123']

        expect(io.string).to eq %("test","0123"\r\n)
      end
    end

    context 'given numeric values' do
      specify do
        csv << [123, -987]

        expect(io.string).to eq %(123,-987\r\n)
      end
    end

    context 'given string and numeric values' do
      specify do
        csv << ['test', 123, '0987']

        expect(io.string).to eq %("test",123,"0987"\r\n)
      end
    end

    context 'given string values with the quotation character' do
      specify do
        csv << ['test of "quoted"']

        expect(io.string).to eq %("test of ""quoted"""\r\n)
      end
    end

    context 'when called more than once' do
      specify do
        csv << ['test1', 123]
        csv << ['test2', -987]

        expect(io.string).to eq %("test1",123\r\n"test2",-987\r\n)
      end
    end
  end
end
