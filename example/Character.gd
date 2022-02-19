extends Control

func _process(_delta):
	$Label.set_text($StateMachine.current)
