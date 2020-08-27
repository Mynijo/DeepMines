extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func add_condition(_condition):
	_condition.set_parent(get_parent())	
	if self.get_child_count() == 0:
		get_parent().remove_tags()
	add_child(_condition)
		
func remove_condition(_condition):
	remove_child(_condition)
	if get_child_count() == 0:
		get_parent().rewrite_tags()



