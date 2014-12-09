# CsvGenerator

[![Build Status](https://semaphoreapp.com/api/v1/projects/ad79168d-d8c1-45c5-9a25-6e8354304f83/300861/badge.png)](https://semaphoreapp.com/cesare/csv_generator)

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

Basic usage is something like this:

```ruby
CsvGenerator.open('example.csv') do |csv|
  csv << ['0123', 456, 'this is a string']
end
# writes to example.csv:
# "0123",456,"this is a string"
```

If you have multiple rows,

```ruby
rows = [
  ['0123', 456, 'this is a string'],
  ['1234', 987, 'this is the second row']
]

CsvGenerator.open('example.csv') do |csv|
  rows.each do |row|
    csv << row
  end
end
# writes to example.csv:
# "0123",456,"this is a string"
# "1234",987,"this is the second row"
```

Or using `CsvGenerator#generate`,

```ruby
rows = [
  ['0123', 456, 'this is a string'],
  ['1234', 987, 'this is the second row']
]

CsvGenerator.open('example.csv').generate(rows)
# writes to example.csv:
# "0123",456,"this is a string"
# "1234",987,"this is the second row"
```

Data source of a row does not have to be an array.
If you have objects (such as ActiveRecord instances),

```ruby
class User
  attr_reader :name, :score
end

users = [
  User.new(name: 'test1', score: 123),
  User.new(name: 'test2', socre: 987)
]

CsvGenerator.open('example.csv') do |csv|
  csv.generate(users) do |user|
    [user.name, user.score]
  end
end
# writes to example.csv:
# "test1",123
# "test2",987
```

If you need a string instead of a file, use StringIO like this:

```ruby
io = StringIO.new
CsvGenerator.new(io) do |csv|
  csv << ['test', 123]
end

io.string # => "test",123
```

## Contributing

1. Fork it ( https://github.com/cesare/csv_generator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
