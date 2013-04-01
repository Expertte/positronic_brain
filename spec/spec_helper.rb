# encoding: utf-8
root_path = File.expand_path File.join(File.dirname(__FILE__), '..')
load File.join(root_path, 'lib/positronic_brain.rb')

require 'rspec/mocks'
require 'pry'

PositronicBrain::Base.dump_path = File.join(root_path, 'tmp/dump')

matchers = []
Dir[File.join(root_path, 'spec/matchers/**/*.rb')].each do |file|
  require file
  matchers << File.basename(file).gsub('.rb', '').camelize.constantize
end

RSpec.configure do |config|
  matchers.each do |matcher|
    config.include matcher
  end
end

TRAIN_BASE = [
  ['Nobody owns the water.',                :good],
  ['the quick rabbit jumps fences',         :good],
  ['the quick brown fox jumps',             :good],
  ['buy pharmaceuticals now',               :bad ],
  ['make quick money at the online casino', :bad ]
]
