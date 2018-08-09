require 'csv_generator/version'

class CsvGenerator
  attr_reader :io

  class << self
    def open(path, options = {})
      mode = options[:mode] || 'w'
      permission = options[:permission] || 0644

      File.open(path, mode, permission) do |io|
        generator = new(io, options)
        yield generator

        generator
      end
    end
  end

  def initialize(io, options = {})
    @io = io
    @options = options
  end

  def generate(enumerable)
    enumerable.each do |row_instance|
      if block_given?
        self << (yield row_instance)
      else
        self << row_instance
      end
    end
  end

  def <<(row_values)
    io.write row_generator.generate(row_values)
  end

  private

  def row_generator
    @row_generator ||= RowGenerator.new(@options)
  end

  class RowGenerator
    KNOWN_OPTIONS = %i(line_separator field_separator quote_character).freeze

    attr_reader(*KNOWN_OPTIONS)
    attr_reader :escaped_quote

    def initialize(options = {})
      default_config.merge(filter_options options).each do |k, v|
        instance_variable_set :"@#{k}", v
      end

      @escaped_quote = quote_character * 2
    end

    private

    def filter_options(hash)
      hash.select { |k, _| KNOWN_OPTIONS.include? k }
    end

    def default_config
      {
        line_separator: "\r\n",
        field_separator: ',',
        quote_character: '"',
      }
    end

    def escape_quote_character(c)
      c * 2
    end

    public

    def generate(row_values)
      row_values.map { |value| stringify value }.join(field_separator) + line_separator
    end

    private

    def stringify(value)
      case value
      when nil
        ''
      when String
        quote value
      when 0.class, Float
        value.to_s
      else
        stringify value.to_s
      end
    end

    def quote(str)
      escaped_string = str.gsub quote_character, escaped_quote
      quote_character + escaped_string + quote_character
    end
  end
end
