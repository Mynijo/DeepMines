extends "res://effects/scripts/StatusEffect.gd"

export (float) var holy_duration = 0.5

func _init():
	$Tags.add_tag($Tags.e_effect.debuff)
	$Tags.add_tag($Tags.e_effect.init)
	$Tags.add_tag($Tags.e_effect.took_dmg)
	$Tags.add_tag($Tags.e_effect.has_icon)
	
func effekt(value, tag):
	if tag == $Tags.e_effect.init:
		parent = value
	if tag == $Tags.e_effect.took_dmg:
		var StatusEffektDmgImun = load("res://effects/StatusEffectDmgImun.tscn").instance()
		StatusEffektDmgImun.duration = holy_duration
		parent.add_Status(StatusEffektDmgImun)
		return value
func get_description():
	var des = "Add Holy Shild after dmg taken for " + str(holy_duration) + " Seconds"
	return des
