extends "res://Rune/RuneEffect.gd"

export (PackedScene) var status

func _init():
	$Tags.add_tag($Tags.e_rune.effect_attack)
	$Tags.add_tag($Tags.e_rune.init_attack)
	$Tags.add_tag($Tags.e_rune.enemy_was_dmg)

func effect(_obj, _tag):
	if _tag == $Tags.e_rune.enemy_was_dmg:
		if _obj.has_method('add_Status'):
			var s = status.instance()
			_obj.add_Status(s)
