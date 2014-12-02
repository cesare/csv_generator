require 'rake/clean'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

CLOBBER << 'pkg'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
end
