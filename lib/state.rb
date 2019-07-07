# frozen_string_literal: true

class State
  attr_reader :name, :before, :after

  def initialize(name:, before: nil, after: nil)
    @name = name.to_sym
    @before = before
    @after = after
  end

  def ==(other)
    name ==
      if other.is_a?(Symbol)
        other
      else
        other.name
      end
  end

  def to_s
    name
  end
end
