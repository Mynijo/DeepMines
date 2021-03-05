extends "res://effects/conditions/scripts/Condition.gd"


export (float) var health_percent = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	parent.connect("parent_ready", self, "parent_ready")

func parent_ready(_parent):
	parent.get_target().connect("health_changed",self, "parent_health_changed")
	
func parent_health_changed(_health):
	if _health <= parent.get_target().max_health * health_percent:
		delete_me()
