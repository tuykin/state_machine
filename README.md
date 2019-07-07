# State Machine

Custom State Machine implementation

Implement a simple library that allows defining state machines. Ensure good test coverage of the library.

An example of a state machine definition:

``` ruby
class MovementState
  include StateMachine

  state :standing, initial: true
  state :walking
  state :running

  event :walk do
    transitions from: :standing, to: :walking
  end

  event :run do
    transitions from: [:standing, :walking], to: :running
  end

  event :hold do
    transitions from: [:walking, :running], to: :standing
  end
end

movement_state = MovementState.new(:standing)
movement_state.walk!
movement_state.walking? # => true
movement_state.can_walk? # => false
movement_state.can_run? # => true
```

Consider implementing the following features:

+ Ensure that the definition of the state machine is valid (e.g., only a single initial state, no undefined states in transition definitions).
+ Raise an error when the event doesn't have any transitions allowed for the current state.
+ Define callbacks for entering a state, leaving a state or making a particular transition.
+ Check if the event can be triggered (e.g., by calling `#can_walk?`).
- Define guard clauses for transitions by providing `:when` option to a transition definition. It can accept either a lambda, which implements the guard clause, or a symbol, which references the method name.

Bonus task:
- Write a script to generate a diagram for the state machine showing states and possible transitions (e.g., using `graphviz` gem).

TODO:
- where to setup state? initialize - bad solution. It's not override-safe
- guards
- replace guard with when
- provide -> lambda
- diagram
- extract states_collection to class
- extract transition to class
- extract event to class
- check if method already defined
- how to initialize on include?
- check if event has more than one transitions statements
- check if event exists
- wrap to gem
- resolve TODOs
- what else should be checked in SM definition?
- how initial state is being used?

QUESTIONS:
- constructor is being overriden?
- initial state required?
- can we redefine state?
- should raise InvalidCallback?
- guarded transition should raise error on bang?