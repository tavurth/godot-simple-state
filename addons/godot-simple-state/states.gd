extends Node

signal state_changed(new_state)

onready var _Parent = get_parent()

var allowed: Dictionary = {}
export(bool) var logging: bool = false
export(String) var current: String = ""

var states = {}


func logger(to_log: String):
	print("[SimpleState]: %s, %s" % [_Parent.name, to_log])


func _ready():
	self.setup()


func now(state: String):
	"""
	Simpler helper so you can do things like

	if States.now("afraid"):
		pass
	"""
	return current == state


func restart(arg = null):
	"""
	Restarts the current state
	This only calls "_state_enter" again
	it does not reset any variables
	"""
	self.call("_state_enter", arg)


func setup():
	"""
	Removes all child states and saves them to our state map
	We will then mount the current state so it can still receive
	the godot input methods such as _physics_process
	"""
	for child in self.get_children():
		states[child.name] = child

		if "States" in child:
			child.States = self

		if "Parent" in child:
			child.Parent = _Parent

		if child.name != current:
			self.remove_child(child)


	self.restart()

func goto(state: String, args = null):
	"""
	Changes to another state
	If a state is loaded it will first call "_state_exit"
	The loaded state will enter with "_state_enter"
	"""
	if not state in states:
		push_error("Could not find state %s in state list" % state)
		return

	# Don't change state to the same state
	if state == current:
		return

	self.call("_state_exit")

	if len(current):
		self.logger("Exiting state %s" % current)
		self.remove_child(states[current])

	self.current = state
	self.emit_signal("state_changed", current)
	self.logger("Entering state %s" % current)
	self.add_child(states[current])

	self.call("_state_enter", args)


func call(method: String, args = null):
	"""
	Call a method on the current state with arguments
	Accepts:
	 - Single argument
	 - Array argument (spread over function)
	 - No argument
	"""
	if not len(current) or not current in states:
		return

	if not states[current].has_method(method):
		return

	self.logger("Calling %s" % method)
	if args != null:
		return states[current].call(method, args)

	else:
		return states[current].call(method)

func _call(args, method: String):
	"""
	Inbound hook for attaching signals
	Bind the custom method name
	"""
	return self.call(method, args)
