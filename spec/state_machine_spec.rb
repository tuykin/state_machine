require 'state_machine'
require 'models/movement_state'

describe StateMachine do
  let(:klass) { MovementState }
  let(:obj) { klass.new }

  # TODO: remove
  describe 'test' do
    it do
      obj.walk!
      p obj.state
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

    it 'should define only allowed states'
  end

  describe 'events' do
    it 'should transit to walking' do
      expect(obj.standing?).to be true
      expect(obj.walking?).to be false
      expect(obj.state).to eq(:standing)

      obj.walk!

      expect(obj.standing?).to be false
      expect(obj.walking?).to be true
      expect(obj.state).to eq(:walking)
    end

  end

  describe 'transitions' do
    it 'should raise error when transition not allowed'
    it 'should have no undefined states (in transitions)'
  end
end
