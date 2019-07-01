require 'state_machine'

describe StateMachine do
  let(:test_class) { Class.new { include StateMachine } }
  let(:obj) { test_class.new }

  describe '#test' do
    subject { obj.test }
    it { is_expected.to eq('test') }
  end
end
