extends "res://buildings/tower/traps/Trap.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	map = get_tree().get_root().get_node("map")
	$Node/RayCast2D.cast_to.y = 50000


func _process(delta):
	if ray.is_colliding():
		if ray.get_collider().is_in_group("enemys"):
			if can_shoot:
				shoot()
				charges -= 1
				if charges <= 0:
					delete_me()