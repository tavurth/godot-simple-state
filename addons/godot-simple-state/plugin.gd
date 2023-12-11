@tool
extends EditorPlugin


static func get_icon(name: String) -> Texture2D:
	return load("res://addons/godot-simple-state/icon_" + name + ".png") as Texture2D


func _enter_tree():
	add_custom_type(
		"StateMachine",
		"Node",
		preload("res://addons/godot-simple-state/states.gd"),
		load("res://addons/godot-simple-state/icon.png")
	)


func _exit_tree():
	remove_custom_type("StateMachine")
