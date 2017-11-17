# Bundler
require 'bundler/gem_tasks'

# RSpec
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

# RuboCop
require 'rubocop/rake_task'
RuboCop::RakeTask.new

task default: %i[spec rubocop]
