require 'state_machine'
require 'state'
require 'models/callback_state'

describe CallbackState do
  let(:obj) { described_class.new }

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