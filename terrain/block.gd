extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func spawn(_position):
	global_position = _position

func _on_Block_input_event(_viewport, _event, _shape_idx):
	if (_event is InputEventMouseButton and _event.pressed and _event.button_index == BUTTON_LEFT):
		pass
