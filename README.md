# CsvGenerator

Just a CSV generator :)
It ensures string fields quoted.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'csv_generator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install csv_generator

## Usage

```ruby
CsvGenerator.create('example.csv') do |csv|
  csv << ['0123', 456, 'this is a string']
end
# writes to example.csv:
# "0123",456,"this is a string"
```

## Contributing

1. Fork it ( https://github.com/cesare/csv_generator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
