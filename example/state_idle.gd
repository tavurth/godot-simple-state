extends Node2D

# These will be autofilled by the StateMachine
# Parent is our Character node (parent of StateMachine)
var Parent

# States is the StateMachine itself
var States


func _state_enter():
	print("Idle state entered")

	await get_tree().create_timer(1).timeout

	States.goto("attack", ["bob", "ben"])


func _state_exit():
	print("Idle state exiting")


func _physics_process(_delta):
	if Engine.get_process_frames() % 40 == 0:
		print("In Idle state")
