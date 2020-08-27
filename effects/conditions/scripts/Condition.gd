extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var parent

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func delete_me():
	get_parent().remove_condition(self)
	self.queue_free()

func set_parent(_parent):
	parent = _parent
