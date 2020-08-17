extends "res://Rune/RuneEffect.gd"

export (int) var chain
export (int) var detect_distance

var chain_counter = 0
var target_hits = []
var target = []
var detect_radius_shape
var first = false


func _init():
	$Tags.add_tag($Tags.e_rune.enemy_was_hit)
	$Tags.add_tag($Tags.e_rune.effect_attack)
	$Tags.add_tag($Tags.e_rune.init_attack)
	
func effect(_obj, _tag):
	if _tag == $Tags.e_rune.init_attack:
		sort_Obj(_obj)
	if _tag == $Tags.e_rune.enemy_was_hit:
		target_hits.append(_obj)
		return chain()

	
func chain():
	var continue_ = false
	
	chain_counter += 1
	
	
	if chain_counter >= chain:
		continue_ = true
		return continue_
	
	var closestTaget = null
	var newOne = true
	
	find_targets()
	
	for x in target:
		newOne = true
		for y in target_hits:
			if x == y:
				newOne = false
				pass
		if newOne:
			if closestTaget == null:
				closestTaget = x
			else:
				if (x.global_position - attack.global_position).length() < (closestTaget.global_position - attack.global_position).length():
					closestTaget = x
	
	if closestTaget:
		var distance = (closestTaget.global_position - attack.global_position).length()
		var _time = (distance / attack.get_speed())
		var predicted_position = closestTaget.global_position + (closestTaget.get_velocity() * _time)
		
		var dir = (predicted_position - attack.global_position).normalized()
		attack.rotation = dir.angle()
		attack.velocity = dir * attack.get_speed()
	else:
		continue_ = true
		return continue_
	
	continue_ = false
	return continue_

	
func find_targets():
	target.clear()
	var enemys = attack.get_tree().get_nodes_in_group("enemys")
	for e in enemys:
		if !target_hits.has(e):
			if  attack.global_position.distance_to(e.global_position) <= detect_distance:
				target.append(e)
