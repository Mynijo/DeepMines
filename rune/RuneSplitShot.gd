extends "res://Rune/RuneEffect.gd"

export (float) var splitt_angle = 1

signal shoot

func _init():
	$Tags.add_tag($Tags.e_rune.enemy_was_hit)
	$Tags.add_tag($Tags.e_rune.init_attack)
	$Tags.add_tag($Tags.e_rune.init_tower)
	
func effect(_obj, _tag):
	if _tag == $Tags.e_rune.init_tower:
		sort_Obj(_obj)
		self.connect("shoot", tower.get_tree().get_current_scene(), "_on_Tower_shoot")
		$Tags.remove_tag($Tags.e_rune.init_tower)
	if _tag == $Tags.e_rune.init_attack:
		sort_Obj(_obj)
	if _tag == $Tags.e_rune.enemy_was_hit:		
		if _obj.is_in_group("enemys"):
			var temp_splitt = rand_range(0.1,splitt_angle)
			shoot(_obj, temp_splitt)
			shoot(_obj, -temp_splitt)
		return true
			


func shoot(_obj, _splitt):
	var _attack = tower.Attack.instance()
	_attack.damage -= int (_attack.damage/2)
	_attack.ignor_target = _obj
	var temp = attack.rotation + _splitt
	call_deferred("emit_signal", "shoot", _attack, attack.global_position, Vector2(1, 0).rotated(temp), tower)
