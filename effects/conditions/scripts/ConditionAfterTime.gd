extends "res://effects/conditions/scripts/Condition.gd"


export (float) var duration = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = duration
	$Timer.start()


func get_condition_text():
	return "Aktivates after " + str(duration) + " Seconds"


func _on_Timer_timeout():
	delete_me() # Replace with function body.
