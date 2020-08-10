extends "res://effects/scripts/StatusEffect.gd"

export (PackedScene) var status

func _init():
	$Tags.add_tag($Tags.e_rune.effect_attack)
	$Tags.add_tag($Tags.e_rune.init_attack)
	$Tags.add_tag($Tags.e_rune.enemy_was_dmg)

func effect(_obj, _tag):
	if _tag == $Tags.e_rune.enemy_was_dmg:
		if _obj.has_method('add_Status'):
			var s = status.instance()
			#s.add_tag(s.e_effect.dont_stack)
			_obj.add_Status(s)
