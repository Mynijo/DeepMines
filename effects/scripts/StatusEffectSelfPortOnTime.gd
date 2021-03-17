extends "res://effects/scripts/StatusEffect.gd"

export (float) var port_timer = 1

func _init():
	$Tags.add_tag($Tags.e_effect.buff)
	$Tags.add_tag($Tags.e_effect.init)
	$Tags.add_tag($Tags.e_effect.has_icon)
	
func effekt(value, tag):
	if tag == $Tags.e_effect.init:
		port_timer = rand_range(port_timer *  0.8, port_timer * 1.2)
		$Timer.wait_time = port_timer
		parent = value
		$Timer.start()
	

func _on_Timer_timeout():
	parent.global_position = parent.way_points[0][0]
	$Timer.start()
