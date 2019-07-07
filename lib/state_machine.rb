# frozen_string_literal: true

module StateMachine
  InitialStateDuplicateError = Class.new(RuntimeError)
  StateAlreadyDefinedError = Class.new(RuntimeError)
  InvalidStateError = Class.new(RuntimeError)
  InvalidTransitionError = Class.new(RuntimeError)

  def self.included(base)
    base.extend(ClassMethods)

    base.send(:setup)
  end

  def initialize(state = nil)
    @state = state || self.class.initial_state

    super()
  end

  def states
    self.class.states
  end

  def events
    self.class.events
  end

  def state
    @state
  end

  private

  def transit(to)
    if states.include?(to)
      @state = to
      true
    else
      false
    end
  end

  def fire(event_name)
    if can_fire?(event_name)
      transit(events[event_name][:to])
      true
    else
      false
    end
  end

  def fire!(event_name)
    raise InvalidTransitionError unless fire(event_name)
  end

  def can_fire?(event_name)
    events[event_name][:from].include?(state)
  end

  module ClassMethods
    def states
      @states
    end

    def events
      @events
    end

    def initial_state
      @initial_state
    end

    def state(name, initial: false)
      state = name # TODO: extract to class

      add_state(state)

      define_method "#{state}?" do
        self.state == state
      end

      setup_initial_state(state) if initial
    end

    def event(name, &block)
      @events[name] = yield block

      define_method "#{name}!" do
        fire!(name)
      end

      define_method "can_#{name}?" do
        can_fire?(name)
      end
    end

    def transitions(from:, to:)
      from = [*from]

      raise InvalidStateError unless from.any? { |s| states.include?(s) }
      raise InvalidStateError unless states.include?(to)

      { from: [*from], to: to }
    end

    private

    def setup
      @states ||= []
      @events ||= {}
    end

    def setup_initial_state(state)
      raise InitialStateDuplicateError unless initial_state.nil?

      @initial_state = state
    end

    def add_state(state)
      raise StateAlreadyDefinedError if @states.include?(state)

      @states << state
    end
  end
end
