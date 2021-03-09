extends "res://effects/scripts/StatusEffect.gd"

func _init():
	$Tags.add_tag($Tags.e_effect.debuff)
	$Tags.add_tag($Tags.e_effect.init)
	$Tags.add_tag($Tags.e_effect.took_dmg)
	$Tags.add_tag($Tags.e_effect.has_icon)
	
func effekt(value, tag):
	if tag == $Tags.e_effect.init:
		parent = value
	if tag == $Tags.e_effect.took_dmg:
		if value > 0:
			parent.global_position = parent.way_points[0][0]
		return value
	

func get_effect_text():
	var text = "Port unit 1 field on dmg taken"
	return  text
