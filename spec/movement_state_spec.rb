require 'state_machine'
require 'state'
require 'models/movement_state'

describe MovementState do
  let(:obj) { described_class.new }

  describe '#initialization' do
    it do
      expect(obj.class).to eq(described_class)
    end
  end

  describe 'states' do
    it 'should have all states defined' do
      expect(described_class.states).to eq([:standing, :walking, :running])
    end

    it 'should have initial state' do
      expect(described_class.initial_state).to eq(:standing)
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
      expect(described_class.new(:walking).state).to eq(:walking)
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
end
