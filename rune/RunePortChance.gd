extends "res://Rune/RuneEffect.gd"

export (float) var port_chance
export (PackedScene) var emun_status


func _init():
	$Tags.add_tag($Tags.e_rune.enemy_was_dmg)
	$Tags.add_tag($Tags.e_rune.init_tower)
	
func effect(_obj, _tag):
	if _tag == $Tags.e_rune.init_attack:
		sort_Obj(_obj)
	if _tag == $Tags.e_rune.enemy_was_dmg:
		if _obj.is_in_group("enemys"):
			var is_immune = is_enemy_port_immune(_obj)
			if not is_immune:
				if rand_range(0,100) <= (port_chance):
					var spawner = _obj.get_spawner()
					var spawner_pos = spawner.get_pos()
					port_enemy(_obj, spawner_pos)
			
func port_enemy(_enemy, _position):
	_enemy.global_position = _position
	_enemy.way_points.clear()
	if _enemy.has_method('add_Status'):
		var s = emun_status.instance()
		_enemy.add_Status(s)
		
func is_enemy_port_immune(_enemy):
	var effects = _enemy.get_StatusEffects()
	
	for eff in effects:
		if eff.has_method('is_port_immunen'):
			return eff.is_port_immune()
	return false
	
	
	
	
