extends "res://effects/scripts/StatusEffect.gd"

export (float) var push_rate
export (PackedScene) var status

var dir

func _init():
	$Tags.add_tag($Tags.e_effect.speed)
	$Tags.add_tag($Tags.e_effect.direction)
	$Tags.add_tag($Tags.e_effect.debuff)
	
	
func effekt(value, tag):
	if tag == $Tags.e_effect.speed:
		return push_rate
	if tag == $Tags.e_effect.direction:
		return dir
	return value
	
func refresh(_obj):
	pass
	
func _on_Duration_timeout():
	var t = get_parent()
	if t.has_method('add_Status'):
		var s = status.instance()
		s.duration = 0.5
		s.SlowRate = 0
		s.freez_chance = 0
		s.remove_tag($Tags.e_effect.animation)
		s.add_tag($Tags.e_effect.dont_stack)
		t.add_Status(s)
	delteYou()
