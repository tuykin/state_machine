require 'state_machine'
require 'movement_state'

describe StateMachine do
  let(:test_class) { MovementState }
  let(:obj) { test_class.new }

  describe '#initialization' do
    it do
      expect(obj.class).to eq(test_class)
    end
  end

  describe 'states' do
    it 'should have all states defined' do
      expect(obj.states).to eq([:standing, :walking, :running])
    end

    it 'should be in initial state' do
      expect(obj.standing?).to be true
      expect(obj.walking?).to be false
      expect(obj.running?).to be false
    end

    it 'should have only one initial state'
    it 'should define state only once'
    it 'should be initialized with custom state'
  end

  # describe 'events'
  # describe 'transitions' do
  #   it 'should have no undefined states (in transitions)'
  # end
end
