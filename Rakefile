require 'graphviz'

require_relative 'lib/state'
require_relative 'lib/state_machine'
require_relative 'lib/graph'

task :draw do
  filepath = ENV['path']
  require_relative filepath
  filename = File.basename(filepath, '.rb')
  klass = Object.const_get(filename.split('_').map(&:capitalize).join)
  g = Graph.new(klass)
  p res_filename = "#{filename}.png"
  g.g.output(png: res_filename)
end