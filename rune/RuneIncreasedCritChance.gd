extends "res://Rune/RuneEffect.gd"

export (float) var increase_amount 
export (float) var flat_amount 

func _init():
	$Tags.add_tag($Tags.e_rune.effect_attack)
	$Tags.add_tag($Tags.e_rune.init_attack)

func effect(_obj, _tag):
	if _tag == $Tags.e_rune.init_attack:
		sort_Obj(_obj)
	if _tag == $Tags.e_rune.effect_attack:
		if attack.has_method('effect_crit_chance'):
			attack.effect_crit_chance(attack.get_crit_chance() * increase_amount + flat_amount)
