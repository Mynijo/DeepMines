extends "res://Rune/RuneEffect.gd"

export (float) var increase
export (float) var flat

func _init():
	$Tags.add_tag($Tags.e_rune.effect_attack)
	$Tags.add_tag($Tags.e_rune.init_attack)
	
func effect(_obj, _tag):
	if _tag == $Tags.e_rune.init_attack:
		sort_Obj(_obj)
	if _tag == $Tags.e_rune.effect_attack:
		if attack.has_method('effect_damage'):
			attack.effect_damage(attack.get_damage() * increase + flat)
