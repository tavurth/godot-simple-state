extends Node2D

# These will be autofilled by the StateMachine
# Parent is our Character node (parent of StateMachine)
var Parent

# States is the StateMachine itself
var States


func _state_enter(who_to_attack: Array):
	print("Attack state entered, attacking %s people" % len(who_to_attack))

	await get_tree().create_timer(1).timeout

	States.goto("idle")


func _state_exit():
	print("Attack state exiting")


func _physics_process(_delta):
	if Engine.get_process_frames() % 40 == 0:
		print("In Attack state")
