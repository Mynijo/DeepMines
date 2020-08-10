extends "res://Rune/RuneEffect.gd"

func _init():
	$Tags.add_tag($Tags.e_rune.init_attack)
	$Tags.add_tag($Tags.e_rune.whlie_processing)

var x = 8
var y = 0

export (float) var incrase

func effect(_obj, _tag):
	if _tag == $Tags.e_rune.init_attack:
		sort_Obj(_obj)
	if _tag == $Tags.e_rune.whlie_processing:
		var dir = attack.get_direction()		
		dir = dir.rotated(_obj * x)
		y = y + _obj * x
		if y >= 3.1415:
			x = 4
		if attack.has_method('effect_direction'):
			attack.effect_direction(dir)
