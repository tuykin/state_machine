# frozen_string_literal: true

module StateMachine
  def self.included(base)
    base.extend(ClassMethods)
  end

  def states
    self.class.states
  end

  module ClassMethods
    def setup
      @@states ||= []
    end

    def states
      @@states
    end

    def state(name, initial: false)
      setup

      @@states << name
    end
  end
end
