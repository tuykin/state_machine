class InvalidStateClass
  include StateMachine

  state :standing, initial: true

  event :walk do
    transitions from: :standing, to: :walking
  end
end