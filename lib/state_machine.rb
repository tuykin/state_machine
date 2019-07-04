# frozen_string_literal: true

module StateMachine
  InitialStateDuplicateError = Class.new(RuntimeError)

  def self.included(base)
    base.extend(ClassMethods)
  end

  def initialize(state = nil)
    @state = state || self.class.initial_state

    super()
  end

  def states
    self.class.states
  end

  def state
    @state
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

      add_state(state)

      define_method "#{state}?" do
        self.state == state
      end

      setup_initial_state(state) if initial
    end

    private

    def setup_initial_state(state)
      raise InitialStateDuplicateError unless initial_state.nil?

      @initial_state = state
    end

    def add_state(state)
      @states << state
    end
  end
end
