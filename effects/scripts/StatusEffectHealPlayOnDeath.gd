extends "res://effects/scripts/StatusEffect.gd"

export (int) var heal_value

func _init():
	$Tags.add_tag($Tags.e_effect.init)
	$Tags.add_tag($Tags.e_effect.cast_on_death)
	$Tags.add_tag($Tags.e_effect.debuff)
	$Tags.add_tag($Tags.e_effect.has_icon)
	
func effekt(value, tag):
	if tag == $Tags.e_effect.init:
		parent = value
	if tag == $Tags.e_effect.cast_on_death:		
		Player.heal(heal_value)
	return value
	
func get_effect_text():
	return "Heal Player " + String(heal_value) + " on death"
