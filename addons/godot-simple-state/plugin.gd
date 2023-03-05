@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type(
		"StateMachine",
		"Node",
		preload("res://addons/godot-simple-state/states.gd"),
		preload("res://addons/godot-simple-state/icon.png")
	)


func _exit_tree():
	remove_custom_type("StateMachine")
