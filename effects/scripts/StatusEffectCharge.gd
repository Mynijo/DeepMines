extends "res://effects/scripts/StatusEffect.gd"


export (float) var inc_speed = 1.2
export (float) var max_inc_speed = 5
export (float) var tick_rate = 0.2

var inc_speed_actual = 1
var last_direction_angle = null

var ready = true


func _init():
	$Tags.add_tag($Tags.e_effect.animation)
	$Tags.add_tag($Tags.e_effect.dont_stack)
	$Tags.add_tag($Tags.e_effect.direction)
	$Tags.add_tag($Tags.e_effect.speed)
	$Tags.add_tag($Tags.e_effect.debuff)
	$Tags.add_tag($Tags.e_effect.init)
	$Tags.add_tag($Tags.e_effect.has_icon)

func effekt(value, tag):
	if tag == $Tags.e_effect.init:
		$Ticker.wait_time = tick_rate
		$Ticker.start()
		parent = value
	if tag == $Tags.e_effect.speed:
		return value * inc_speed_actual
	if tag == $Tags.e_effect.direction:
		if last_direction_angle == null:
			last_direction_angle = value.angle()
		var temp =  value.angle() - last_direction_angle
		last_direction_angle = value.angle()
		if temp < 1 and temp > -1:
			if ready:
				ready = false
				if inc_speed_actual + inc_speed < max_inc_speed:
					inc_speed_actual += inc_speed
		else:
			inc_speed_actual = 0
	return value


func _on_Ticker_timeout():
	ready = true
