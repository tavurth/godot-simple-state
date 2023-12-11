extends Node

signal state_changed(new_state)

var allowed: Dictionary = {}
@export var host: NodePath
@export var logging := false
@export var current := ""

var states = {}

func get_host() -> Node:
	return get_node(host)


func logger(to_log: String) -> void:
	if not logging: return
	print("[SimpleState]: <%s>, <%s>" % [get_host().name, to_log])


func _enter_tree() -> void:
	self.setup()


func _exit_tree() -> void:
	if current in states:
		self.remove_child(states[current])

	await self.caller("_state_exit")

	for state in states:
		if states[state]:
			states[state].queue_free()

	states = {}
	self.current = "_exit"


func is_current() -> bool:
	"""
	Returns true when called from the current running state
	Returns false from any other state
	"""
	var stack = get_stack()
	if len(stack) < 2: return false
	return stack[1].source == states[current].script.get_path()


func has(state: String) -> bool:
	"""
	Returns true if the <state> exists in our states set
	"""
	return state in states


func now(state: String) -> bool:
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
	await self.caller("_state_enter", arg)


func setup() -> void:
	"""
	Removes all child states and saves them to our state map
	We will then mount the current state so it can still receive
	the godot input methods such as _physics_process
	"""
	for child in self.get_children():
		states[child.name] = child

		if "States" in child:
			child.States = self

		if "states" in child:
			child.states = self

		if "Host" in child:
			child.Host = get_host()

		if "host" in child:
			child.host = get_host()

		if child.name != current:
			self.remove_child(child)


	self.restart()


func goto(state: String, args = null) -> void:
	"""
	Changes to another state
	If a state is loaded it will first call "_state_exit"
	The loaded state will enter with "_state_enter"
	"""
	if not state in states:
		push_error("Could not find state <%s> in state list" % state)
		return

	# Restart the state if we are asked to change to the same
	if state == current:
		return self.restart(args)

	var exiting = await self.caller("_state_exit")

	if len(current):
		self.logger("Exiting state <%s>" % current)
		self.remove_child(states[current])

	self.current = state
	self.emit_signal("state_changed", current)
	self.logger("Entering state <%s>" % current)
	self.add_child(states[current])

	await self.caller("_state_enter", args)


func caller(method: String, args = null):
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

	self.logger("Calling <%s>" % method)
	if args != null:
		return await Callable(states[current], method).call(args)

	else:
		return await Callable(states[current], method).call()

func _call(args, method: String):
	"""
	Inbound hook for attaching signals
	Bind the custom method name
	"""
	return await self.caller(method, args)
