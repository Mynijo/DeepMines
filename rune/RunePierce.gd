extends "res://Rune/RuneEffect.gd"

var pierce = 0
export (int) var max_pierce = 3

func _init():
	$Tags.add_tag($Tags.e_rune.effect_attack)
	$Tags.add_tag($Tags.e_rune.init_attack)
	$Tags.add_tag($Tags.e_rune.enemy_was_hit)
	
func effect(_obj, _tag):
	if _tag == $Tags.e_rune.init_attack:
		sort_Obj(_obj)
	if _tag == $Tags.e_rune.enemy_was_hit:
		pierce += 1
		if pierce < max_pierce:
			return false
		return true