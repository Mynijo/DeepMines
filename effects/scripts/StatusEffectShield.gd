extends "res://effects/scripts/StatusEffect.gd"


export (int) var max_health
export (float) var size_factor = 1

var first = true

func _init():
	$Tags.add_tag($Tags.e_effect.buff)
	$Tags.add_tag($Tags.e_effect.init)
	$Tags.add_tag($Tags.e_effect.animation)

	
func effekt(value, tag):
	if tag == $Tags.e_effect.init:
		parent = value
		$Shield.set_max_health(max_health)
		$Shield.visible = false
		$Shield.scale *= size_factor
	if tag == $Tags.e_effect.animation:
		if first:
			first = false
			$Shield.show()
			$Shield.collision_layer = 4 
		
		$Shield.global_position = parent.global_position
		
func remove_self():
	parent.remove_Status(self)
		
func get_description():
	var des = "Shield absorbs " + str(max_health) + " dmg"
	return des
