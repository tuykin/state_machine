class CallbackState
  include StateMachine

  attr_reader :data

  state :standing, initial: true, before: Proc.new { log('before-standing-proc') }
  state :walking, after: :after_walking
  state :running, before: :before_running, after: :after_running

  event :walk do
    transitions from: :standing, to: :walking,
      before: Proc.new { log('before-walk-proc') }
  end

  event :run do
    transitions from: [:standing, :walking], to: :running, after: :after_run
  end

  event :hold do
    transitions from: [:walking, :running], to: :standing,
      before: :before_hold, after: :after_hold
  end

  def initialize
    @data = []

    super
  end

  def after_run
    log('after-run')
  end

  def before_hold
    log('before-hold')
  end

  def after_hold
    log('after-hold')
  end

  def after_walking
    log('after-walking')
  end

  def before_running
    log('before-running')
  end

  def after_running
    log('after-running')
  end

  private

  def log(str)
    @data << str
  end
end