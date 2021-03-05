extends "res://effects/scripts/StatusEffect.gd"

var dir
var stacks = 1
export (int) var min_stacke = 3
export (float) var inc_speed = 1.2
var target

func _init():
	$Tags.add_tag($Tags.e_effect.dont_stack)
	$Tags.add_tag($Tags.e_effect.debuff)
	$Tags.add_tag($Tags.e_effect.init)
	$Tags.add_tag($Tags.e_effect.has_icon)
	
func effekt(value, tag):
	if tag == $Tags.e_effect.init:
		parent = value
	if tag == $Tags.e_effect.speed:
		return value * inc_speed
	if tag == $Tags.e_effect.direction:
		find_target()
		if !target:			
			return value
		else:
			return (parent.global_position - target.global_position).normalized()
	return value
	
func refresh(_obj):
	stacks += 1
	.refresh(_obj)	
	if stacks >= min_stacke:
		$Tags.add_tag($Tags.e_effect.speed)
		$Tags.add_tag($Tags.e_effect.direction)
		set_duration(3)
		find_target()
	change_icon()
		
	
func find_target():
	target = null
	var distance = -1
	var enemys = parent.get_tree().get_nodes_in_group("enemys")
	for e in enemys:
		if e != parent:
			if distance > parent.global_position.distance_to(e.global_position) or distance == -1:
				distance = parent.global_position.distance_to(e.global_position)
				target = e
				
func change_icon():
	if stacks == 1:
		update_icon($Icon01)
	else: if stacks == 2:
		update_icon($Icon02)
	else:
		update_icon($Icon03)
