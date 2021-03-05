extends "res://Rune/RuneEffect.gd"

signal shoot
export (float) var scatter

func _init():
	$Tags.add_tag($Tags.e_rune.shoot)
	$Tags.add_tag($Tags.e_rune.init_tower)
	$Tags.add_tag($Tags.e_rune.effect_tower)

func effect(_obj, _tag):
	if _tag == $Tags.e_rune.init_tower:
		sort_Obj(_obj)
		self.connect("shoot", tower.get_tree().get_current_scene(), "_on_Tower_shoot")
		$Tags.remove_tag($Tags.e_rune.init_tower)
	if _tag == $Tags.e_rune.shoot:
		var temp_scatter = rand_range(0.1,scatter)
		shoot(_obj, temp_scatter)
		shoot(_obj, -temp_scatter)
	
func shoot(_obj, _scatter):
	var _attack = tower.Attack.instance()	
	if tower.runes_active:
		_attack.set_runes(tower.runes_active, tower)
	var temp = tower.get_node("Body").rotation + _scatter
	emit_signal("shoot", _attack, tower.global_position, Vector2(1, 0).rotated(temp), tower)
	
