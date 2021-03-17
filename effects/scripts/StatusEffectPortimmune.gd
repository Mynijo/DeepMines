extends "res://effects/scripts/StatusEffect.gd"


func _init():
	$Tags.add_tag($Tags.e_effect.buff)
	$Tags.add_tag($Tags.e_effect.has_icon)

func is_port_immune():
	return true
