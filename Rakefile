begin
  require 'bundler/setup'
rescue LoadError
  fail 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rdoc/task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'BetterUUID'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Bundler::GemHelper.install_tasks

desc 'Run RSpec specs'
task :spec do
  ARGV.delete 'spec'
  sh "bundle exec rspec #{ARGV.join ' '}"
end

desc 'Benchmark'
task :benchmark do
  sh "bundle exec ruby lib/benchmark.rb"
end

task default: :spec
