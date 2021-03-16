extends "res://Rune/RuneEffect.gd"

export (int) var increase_amount = 1.5

func _init():
	$Tags.add_tag($Tags.e_rune.init_tower)
	$Tags.add_tag($Tags.e_rune.effect_tower)

func effect(_obj, _tag):
	if _tag == $Tags.e_rune.init_tower:
		sort_Obj(_obj)
	if _tag == $Tags.e_rune.effect_tower:
		if tower.has_method('change_gun_cooldown'):
			tower.change_gun_cooldown(tower.get_gun_cooldown() / increase_amount)
