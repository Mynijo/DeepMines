extends Node

signal pick_up_relic

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func add_relic(_Relic):
	add_child(_Relic)
	_Relic.activate()
	emit_signal('pick_up_relic', _Relic)


func get_relics():
	return get_children()

func remove_relics(_Relic):
	remove_child(_Relic)
	_Relic.queue_free()
	
