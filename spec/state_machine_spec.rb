require 'state_machine'
require 'state'
require 'models/movement_state'
require 'models/callback_state'

describe StateMachine do
  let(:klass) { MovementState }
  let(:obj) { klass.new }

  # TODO: remove
  describe 'test' do
    it do
    end
  end

  describe '#initialization' do
    it do
      expect(obj.class).to eq(klass)
    end
  end

  describe 'states' do
    it 'should have all states defined' do
      expect(klass.states).to eq([:standing, :walking, :running])
    end

    it 'should have initial state' do
      expect(klass.initial_state).to eq(:standing)
    end

    it 'should have only one initial state' do
      expect {
        require 'models/initial_state_duplicate_class'
      }.to raise_error(StateMachine::InitialStateDuplicateError)
    end

    it 'should have current state' do
      expect(obj.state).to eq(:standing)
    end

    it 'should be initialized with custom state' do
      expect(klass.new(:walking).state).to eq(:walking)
    end

    it 'should have all states defined' do
      expect(obj.states).to eq([:standing, :walking, :running])
    end

    it 'should be in initial state' do
      expect(obj.standing?).to be true
      expect(obj.walking?).to be false
      expect(obj.running?).to be false
    end

    it 'should define state only once' do
      expect {
        require 'models/state_already_defined_class'
      }.to raise_error(StateMachine::StateAlreadyDefinedError)
    end
  end

  describe 'events' do
    it 'should transit to walking' do
      expect(obj.standing?).to be true
      expect(obj.walking?).to be false
      expect(obj.running?).to be false
      expect(obj.state).to eq(:standing)

      expect(obj.can_walk?).to be true
      expect(obj.can_run?).to be true
      expect(obj.can_hold?).to be false

      obj.walk!

      expect(obj.standing?).to be false
      expect(obj.walking?).to be true
      expect(obj.running?).to be false
      expect(obj.state).to eq(:walking)

      expect(obj.can_walk?).to be false
      expect(obj.can_run?).to be true
      expect(obj.can_hold?).to be true

      obj.run!

      expect(obj.can_walk?).to be false
      expect(obj.can_run?).to be false
      expect(obj.can_hold?).to be true

      obj.hold!

      expect(obj.can_walk?).to be true
      expect(obj.can_run?).to be true
      expect(obj.can_hold?).to be false
    end
  end

  describe 'transitions' do
    it 'should raise error when transition not allowed' do
      expect {
        obj.hold!
      }.to raise_error(StateMachine::InvalidTransitionError)
    end

    it 'should raise error if state undefined' do
      expect {
        require 'models/invalid_state_class'
      }.to raise_error(StateMachine::InvalidStateError)
    end
  end

  describe 'callbacks' do
    let(:obj) { CallbackState.new }

    it 'should fire before transition proc' do
      obj.walk!
      expect(obj.data).to include('before-walk-proc')
    end

    it 'should fire after transition' do
      obj.walk!
      obj.run!
      expect(obj.data).to include('after-run')
    end

    it 'should fire before and after transition' do
      obj.walk!
      obj.run!
      obj.hold!
      expect(obj.data).to include('before-hold')
      expect(obj.data).to include('after-hold')
    end

    it 'should fire before initial proc' do
      expect(obj.data).to include('before-standing-proc')
    end

    it 'should fire after state change' do
      obj.walk!
      expect(obj.data).to include('after-walking')
    end

    it 'should fire before and after state change' do
      obj.walk!
      obj.run!
      expect(obj.data).to include('before-running')
      expect(obj.data).to include('after-running')
    end

    it 'should fire callbacks in right order' do
      obj.walk!
      obj.run!
      obj.hold!

      expect(obj.data).to eq(%w(
          before-standing-proc
          before-walk-proc
          after-walking
          before-running
          after-running
          after-run
          before-hold
          before-standing-proc
          after-hold
        ))
    end
  end
end
