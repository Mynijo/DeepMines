extends "res://effects/scripts/StatusEffect.gd"

export (int) var max_dmg = 1

func _init():
	$Tags.add_tag($Tags.e_effect.buff)
	$Tags.add_tag($Tags.e_effect.init)
	$Tags.add_tag($Tags.e_effect.take_dmg)
	$Tags.add_tag($Tags.e_effect.has_icon)
	
func effekt(value, tag):
	if tag == $Tags.e_effect.init:
		parent = value
	if tag == $Tags.e_effect.take_dmg:
		if value > max_dmg:
			value = max_dmg
		return value
	

func get_description():
	var des = "Enemy get max  " + str(max_dmg) + " dmg"
	return des
