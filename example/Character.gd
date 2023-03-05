extends Control

func _ready() -> void:
	$StateMachine.goto("idle")

func _process(_delta: float) -> void:
	$Label.set_text($StateMachine.current)
