extends "res://Rune/RuneEffect.gd"

var status = preload("res://effects/StatusEffectHoT.tscn")

export (int) var heal_value = 10
export (int) var tick_rate = 10
export (float) var duration = 0.5

func _init():
	$Tags.add_tag($Tags.e_rune.effect_attack)
	$Tags.add_tag($Tags.e_rune.init_attack)
	$Tags.add_tag($Tags.e_rune.process_animation)
	$Tags.add_tag($Tags.e_rune.enemy_was_hit)

func effect(_obj, _tag):
	if _tag == $Tags.e_rune.enemy_was_hit:
		if _obj.has_method('add_Status'):
			var s = status.instance()
			s.heal_value = heal_value
			s.tick_rate = tick_rate
			s.duration = duration
			_obj.add_Status(s)
		return true
