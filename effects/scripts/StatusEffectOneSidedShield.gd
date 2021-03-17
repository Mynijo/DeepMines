extends "res://effects/scripts/StatusEffect.gd"


export (int) var max_health
export (float) var size_factor = 1

var first = true

func _init():
	$Tags.add_tag($Tags.e_effect.buff)
	$Tags.add_tag($Tags.e_effect.init)
	$Tags.add_tag($Tags.e_effect.animation)
	$Tags.add_tag($Tags.e_effect.direction)
	$Tags.add_tag($Tags.e_effect.has_icon)

func find_closest(var value, array):
	var best_match = null
	var least_diff = 100
	for number in array:
		var diff = abs(value - number)
		if(diff < least_diff):
			best_match = number
			least_diff = diff
	return best_match
	
func effekt(value, tag):
	if tag == $Tags.e_effect.init:
		parent = value
		$Shield.set_max_health(max_health)
		$Shield.visible = false
		$Shield.scale *= size_factor    
	if tag == $Tags.e_effect.direction:
		var temp_angle = find_closest(value.angle(),[-PI,-PI/2, -PI*1.5, PI, PI * 1.5, 0 , PI / 2] )
		$Shield.rotation =  temp_angle - PI / 2
		return value
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
