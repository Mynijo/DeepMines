extends Node

enum e_rune{
	enemy_was_hit,
	enemy_was_dmg,
	shoot,
	explode,
	enemy_was_crit,
	effect_tower,
	effect_attack,
	init_attack,
	init_tower,
	whlie_processing,
	process_animation
}

enum e_effect{
	speed = 100,
	health,
	dont_stack,
	cast_on_death,
	init,
	direction,
	animation,
	debuff,
	buff,
	took_dmg
}

enum e_relic{
	pick_up_relic,
	pick_up_me,
	game_stat_change,
	player_take_damage
}


var tags = []


func _ready():
	pass
	
func remove_tag(_tag):
	tags.erase(_tag)

func add_tag(_tag):
	tags.append(_tag)

func get_tags():
	return tags
	
func has_tag(_tag):
	if tags == null:
		return false
	return tags.has(_tag)
