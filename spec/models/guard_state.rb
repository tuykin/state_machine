class GuardState
  include StateMachine

  attr_reader :data
  attr_accessor :flag

  state :standing, initial: true
  state :walking
  state :running

  event :walk do
    transitions from: :standing, to: :walking, guard: :walk_guard,
              before: :before_run
  end

  event :run do
    transitions from: [:standing, :walking], to: :running, guard: -> { flag }
  end

  event :hold do
    transitions from: [:walking, :running], to: :standing, guard: :not_boolean
  end

  def initialize
    @data = []
    @flag = true

    super
  end

  def walk_guard
    flag
  end

  def before_run
    log('before-run')
  end

  private

  def log(str)
    @data << str
  end
end