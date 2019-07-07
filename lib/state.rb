# frozen_string_literal: true

class State
  attr_reader :name, :before, :after

  def initialize(name:, before: nil, after: nil)
    @name = name.to_sym
    @before = before
    @after = after
  end

  def ==(state)
    if state.is_a?(Symbol)
      name == state
    else
      name == state.name
    end
  end

  def to_s
    name
  end
end