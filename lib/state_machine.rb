# frozen_string_literal: true

module StateMachine
  InitialStateDuplicateError = Class.new(RuntimeError)

  def self.included(base)
    base.extend(ClassMethods)
  end

  def states
    self.class.states
  end

  module ClassMethods
    def setup
      @states ||= []
    end

    def states
      @states
    end

    def initial_state
      @initial_state
    end

    def state(name, initial: false)
      setup

      state = name # TODO: extract to class

      @states << state

      setup_initial_state(state) if initial
    end

    private

    def setup_initial_state(state)
      raise InitialStateDuplicateError unless initial_state.nil?

      @initial_state = state
    end
  end
end
