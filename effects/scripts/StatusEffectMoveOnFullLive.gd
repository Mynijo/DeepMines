extends "res://effects/scripts/StatusEffect.gd"

func _init():
	$Tags.add_tag($Tags.e_effect.speed)
	$Tags.add_tag($Tags.e_effect.buff)
	$Tags.add_tag($Tags.e_effect.init)
	$Tags.add_tag($Tags.e_effect.health)
	$Tags.add_tag($Tags.e_effect.took_dmg)	
	$Tags.add_tag($Tags.e_effect.has_icon)

var time_to_run = true
var full_live = true

func effekt(value, tag):
	if tag == $Tags.e_effect.init:
		parent = value
	if tag == $Tags.e_effect.health:
		if parent.health >= parent.max_health:
			full_live = true
		else:
			full_live = false
		return 0
	if tag == $Tags.e_effect.took_dmg:
		if value > 0:
			$Timer.start()
			time_to_run = true
	if tag == $Tags.e_effect.speed:
		if time_to_run or full_live:
			return value
		else:
			return 0
			
	return value
	


func _on_Timer_timeout():
	time_to_run = false

func get_description():
	var des = "Moves only on full live or while took dmg in the last " + str($Timer.wait_time) + " Seconds"
	return des
