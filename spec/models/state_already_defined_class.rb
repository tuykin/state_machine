class StateAlreadyDefinedClass
  include StateMachine

  state :standing, initial: true
  state :standing
end