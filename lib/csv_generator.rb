require "csv_generator/version"

class CsvGenerator
  attr_reader :io

  class << self
    def create(path, mode = 'w', permission = 0644, &block)
      File.open(path, mode, permission) do |io|
        create io, &block
      end
    end

    def with(io, &block)
      generator = new(io)

      yield generator if block_given?
      generator
    end
  end

  def initialize(io)
    @io = io
  end

  def <<(row_values)
    io.write row_generator.generate(row_values)
  end

  private

  def row_generator
    @row_generator ||= RowGenerator.new
  end

  class RowGenerator
    def generate(row_values)
      row_values.map { |value| stringify value }.join(field_separator) + line_separator
    end

    private

    def line_separator
      "\r\n"
    end

    def field_separator
      ','
    end

    def quote_charactor
      '"'
    end

    def escaped_quote
      '""'
    end

    def stringify(value)
      case value
      when nil
        ''
      when String
        quote value
      else
        value
      end
    end

    def quote(str)
      escaped_string = str.gsub quote_charactor, escaped_quote
      %Q{"#{escaped_string}"}
    end
  end
end
