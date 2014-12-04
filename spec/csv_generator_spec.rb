require 'fakefs/spec_helpers'

describe CsvGenerator do
  describe '.generate' do
    context 'given only a file name' do
      include FakeFS::SpecHelpers

      specify do
        CsvGenerator.generate('test.csv') do |csv|
          csv << ['test', 123]
        end

        expect(File.read('test.csv')).to eq %("test",123\r\n)
      end
    end

    context 'given the name of an existing file' do
      include FakeFS::SpecHelpers

      specify do
        File.open('test.csv', 'w') do |file|
          file.write(%("existing line",987\r\n))
        end

        CsvGenerator.generate('test.csv') do |csv|
          csv << ['test', 123]
        end

        expect(File.read('test.csv')).to eq %("test",123\r\n)
      end
    end

    context 'given "a" as mode' do
      include FakeFS::SpecHelpers

      specify do
        File.open('test.csv', 'w') do |file|
          file.write(%("existing line",987\r\n))
        end

        CsvGenerator.generate('test.csv', mode: 'a') do |csv|
          csv << ['test', 123]
        end

        expect(File.read('test.csv')).to eq %("existing line",987\r\n"test",123\r\n)
      end
    end
  end

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

    context 'given float values' do
      specify do
        csv << [1.23, 9.876]

        expect(io.string).to eq %(1.23,9.876\r\n)
      end
    end

    context 'given negative numbers' do
      specify do
        csv << [-123, -0.987]

        expect(io.string).to eq %(-123,-0.987\r\n)
      end
    end

    context 'given nil' do
      specify do
        csv << ['test', nil, 123]

        expect(io.string).to eq %("test",,123\r\n)
      end
    end

    context 'given dates' do
      specify do
        csv << [123, Date.new(2014, 12, 6)]

        expect(io.string).to eq %(123,"2014-12-06"\r\n)
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

  context 'with options' do
    context 'given line_separator' do
      let(:csv) { CsvGenerator.new io, line_separator: "\n" }
      let(:io) { StringIO.new }

      specify do
        csv << ['test', 123]

        expect(io.string).to eq %("test",123\n)
      end
    end

    context 'given field_separator' do
      let(:csv) { CsvGenerator.new io, field_separator: "\t" }
      let(:io) { StringIO.new }

      specify do
        csv << ['test', 123]

        expect(io.string).to eq %("test"\t123\r\n)
      end
    end

    context 'given quote_character' do
      let(:csv) { CsvGenerator.new io, quote_character: "'" }
      let(:io) { StringIO.new }

      specify do
        csv << ['test', %q('single'), %q("double"), 123]

        expect(io.string).to eq %('test','''single''','"double"',123\r\n)
      end
    end
  end
end
