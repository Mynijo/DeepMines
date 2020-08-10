extends "res://Rune/RuneEffect.gd"

func _init():
	$Tags.add_tag($Tags.e_rune.enemy_was_crit)
	$Tags.add_tag($Tags.e_rune.init_tower)
	$Tags.add_tag($Tags.e_rune.effect_attack)
	
func effect(_obj, _tag):
	if _tag == $Tags.e_rune.init_tower:
		sort_Obj(_obj)
	if _tag == $Tags.e_rune.enemy_was_crit:
		if tower:
			tower.shoot()
