extends "res://Rune/RuneEffect.gd"

var status = preload("res://effects/StatusEffectSilince.tscn")

export (float) var silince_duration = 2
export (int) var silince_chance = 5

func _init():
	$Tags.add_tag($Tags.e_rune.effect_attack)
	$Tags.add_tag($Tags.e_rune.init_attack)
	$Tags.add_tag($Tags.e_rune.process_animation)
	$Tags.add_tag($Tags.e_rune.enemy_was_hit)

func effect(_obj, _tag):
	if _tag == $Tags.e_rune.enemy_was_hit:
		if _obj.has_method('add_Status'):
			if rand_range(0,100) <= (silince_chance):
				var s = status.instance()
				s.duration = silince_duration
				s.silince_duration = silince_duration
				_obj.add_Status(s)
		return true
