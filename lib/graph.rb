# frozen_string_literal: true

class Graph
  attr_reader :klass, :g

  def initialize(klass)
    @klass = klass
    @g = GraphViz.new(:G, type: :digraph)

    add_nodes
    add_edges
    add_start_node
  end

  private

  def add_nodes
    klass.states.each { |s| g.add_nodes(s.name.to_s) }
  end

  def add_edges
    klass.events.each do |k, v|
      v[:from].each do |f|
        g.add_edge(g.find_node(f.name.to_s), g.find_node(v[:to].name.to_s), label: k)
      end
    end
  end

  def add_start_node
    g.add_edge('Start', g.find_node(klass.initial_state.name.to_s))
  end
end
