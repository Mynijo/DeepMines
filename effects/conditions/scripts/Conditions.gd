extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var duration

func add_condition(_condition):
	_condition.set_parent(get_parent())	
	if self.get_child_count() == 0:
		get_parent().remove_tags()
	if _condition.start_duaration_after_trigger:
		get_parent().stop_duration()
		duration = get_parent().get_duration()
		get_parent().set_duration(0)
	add_child(_condition)
	
		
func remove_condition(_condition):
	remove_child(_condition)
	if get_child_count() == 0:
		get_parent().rewrite_tags()
		if get_parent().has_icon():
			get_parent().get_target().add_Status_Icon(get_parent())
		get_parent().set_duration(duration)
		get_parent().start_duration()
