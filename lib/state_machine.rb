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

  def initialize(state_name = nil)
    @state = states.select { |s| s.name == state_name }.first || self.class.initial_state

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

  def fire_event(event_name)
    event = events[event_name]

    if can_fire?(event)
      fire_callback(event[:before])
      transit(events[event_name][:to])
      fire_callback(event[:after])
      true
    else
      false
    end
  end

  def fire_event!(event_name)
    raise InvalidTransitionError unless fire_event(event_name)
  end

  def can_fire?(event)
    event[:from].include?(state)
  end

  def fire_callback(callback)
    return if callback.nil?

    if callback.is_a?(Proc)
      instance_eval(&callback)
    else
      send(callback)
    end
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

    def state(name, initial: false, before: nil, after: nil)
      state = State.new(name: name, before: before, after: after)

      add_state(state)

      define_method "#{state.name}?" do
        self.state == state
      end

      setup_initial_state(state) if initial
    end

    def event(name, &block)
      @events[name] = yield block

      define_method "#{name}!" do
        fire_event!(name)
      end

      define_method "can_#{name}?" do
        can_fire?(events[name])
      end
    end

    def transitions(from:, to:, before: nil, after: nil)
      from = [*from]

      raise InvalidStateError unless from.any? { |s| states.include?(s) }
      raise InvalidStateError unless states.include?(to)

      from_states = states.select { |s| from.include?(s.name) }
      to_state = states.select { |s| s.name == to }.first

      { from: from_states, to: to_state, before: before, after: after }
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
