extends "res://Rune/RuneEffect.gd"

var bounced = false
export (float) var incraseLifetime = 2
	
func _init():
	$Tags.add_tag($Tags.e_rune.enemy_was_hit)
	$Tags.add_tag($Tags.e_rune.init_tower)
	$Tags.add_tag($Tags.e_rune.effect_attack)
	$Tags.add_tag($Tags.e_rune.init_attack)

func effect(_obj, _tag):
	if _tag == $Tags.e_rune.init_tower:
		sort_Obj(_obj)
	if _tag == $Tags.e_rune.init_attack:
		sort_Obj(_obj)
	if _tag == $Tags.e_rune.effect_attack:
		attack.effect_lifetime(attack.get_lifetime() * incraseLifetime)
	if _tag == $Tags.e_rune.enemy_was_hit:
		$Tags.remove_tag($Tags.e_rune.enemy_was_hit)
		var dir = (tower.global_position - attack.global_position).normalized()
		attack.rotation = dir.angle()
		attack.velocity = dir * attack.get_speed()
		return false
		


