extends "res://effects/scripts/StatusEffect.gd"

var dir
var stacks = 1
export (int) var min_stacke = 3
export (float) var inc_speed = 1.2
var target

func _init():
	$Tags.add_tag($Tags.e_effect.animation)
	$Tags.add_tag($Tags.e_effect.dont_stack)
	$Tags.add_tag($Tags.e_effect.debuff)
	$Tags.add_tag($Tags.e_effect.init)
	
	
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
	if tag == $Tags.e_effect.animation:
		$Animation.global_position = value.global_position + Vector2(20,-50)
		$Animation.show()
		if stacks >= min_stacke/3 and stacks < (min_stacke/3) *2:
			$Animation.play("charme01") 
		if stacks >= (min_stacke/3) *2 and stacks < min_stacke:
			$Animation.play("charme02") 
		if stacks >= min_stacke:
			$Animation.play("charme03") 
		
	return value
	
func refresh(_obj):
	stacks += 1
	.refresh(_obj)	
	if stacks >= min_stacke:
		$Tags.add_tag($Tags.e_effect.speed)
		$Tags.add_tag($Tags.e_effect.direction)
		set_duration(3)
		find_target()
		
	
func find_target():
	target = null
	var distance = -1
	var enemys = parent.get_tree().get_nodes_in_group("enemys")
	for e in enemys:
		if e != parent:
			if distance > parent.global_position.distance_to(e.global_position) or distance == -1:
				distance = parent.global_position.distance_to(e.global_position)
				target = e
				
