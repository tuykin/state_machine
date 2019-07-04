class InitialStateDuplicateClass
  include StateMachine

  state :standing, initial: true
  state :walking, initial: true
end