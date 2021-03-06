extends "res://Rune/RuneEffect.gd"

export (PackedScene) var status

func _init():
	$Tags.add_tag($Tags.e_rune.effect_attack)
	$Tags.add_tag($Tags.e_rune.enemy_was_dmg)
	$Tags.add_tag($Tags.e_rune.init_attack)
	$Tags.add_tag($Tags.e_rune.process_animation)

func effect(_obj, _tag):
	if _tag == $Tags.e_rune.init_attack:
		sort_Obj(_obj)
	if _tag == $Tags.e_rune.enemy_was_dmg:
		if _obj.has_method('add_Status'):
			var s = status.instance()
			_obj.add_Status(s)
	if _tag == $Tags.e_rune.process_animation:
		$Animation.global_position = _obj.global_position
		$Animation.rotation = _obj.rotation
		$Animation.show()
		$Animation.play("snow")
		return
