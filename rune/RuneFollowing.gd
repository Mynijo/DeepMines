extends "res://Rune/RuneEffect.gd"

func _init():
	$Tags.add_tag($Tags.e_rune.init_tower)
	$Tags.add_tag($Tags.e_rune.enemy_was_dmg)
	$Tags.add_tag($Tags.e_rune.whlie_processing)
	$Tags.add_tag($Tags.e_rune.init_attack)
	
var wr_target
export (float) var turn_speed

func effect(_obj, _tag):
	if _tag == $Tags.e_rune.init_attack:
		sort_Obj(_obj)
		if tower.target:
			wr_target = weakref(tower.target.front())
		else:
			$Tags.remove_tag($Tags.e_rune.whlie_processing)
			return
	if _tag == $Tags.e_rune.init_tower:
		sort_Obj(_obj)
	if _tag == $Tags.e_rune.enemy_was_dmg:
		$Tags.remove_tag($Tags.e_rune.whlie_processing)
	if _tag == $Tags.e_rune.whlie_processing:
		if !wr_target.get_ref():
			#$Tags.remove_tag($Tags.e_rune.whlie_processing)
			if tower.target:
				wr_target = weakref(tower.target.front())
			return
		var target = wr_target.get_ref()
		var dir = attack.get_direction()		
		var distance = (target.global_position - attack.global_position).length()
		var _time = (distance / (attack.get_speed()))
		var predicted_position = target.global_position + (target.get_velocity() * _time)		
		var target_dir = (predicted_position - attack.global_position).normalized()
		dir = dir.linear_interpolate(target_dir, turn_speed * _obj)
		if attack.has_method('effect_direction'):
			attack.effect_direction(dir)