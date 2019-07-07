require 'state_machine'
require 'state'
require 'models/guard_state'

describe GuardState do
  let(:obj) { described_class.new }

  it 'should transit when guard is true' do
    expect(obj.standing?).to be true
    obj.walk!
    expect(obj.walking?).to be true
  end

  it 'should not transit when guard is false' do
    obj.flag = false

    expect(obj.standing?).to be true
    obj.walk!
    expect(obj.standing?).to be true
  end

  it 'should transit when lambda guard is true'
  it 'should not transit when lambda guard is false'

  it 'should not fire callback if guarded' do
    obj.flag = false

    obj.walk!
    expect(obj.data).to be_empty
  end

  it 'should raise error when guard not boolean' do
    obj.flag = 'str'
    expect { obj.walk! }.to raise_error(StateMachine::GuardIsNotBooleanError)
  end
end
