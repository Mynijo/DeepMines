extends "res://effects/scripts/StatusEffect.gd"

export (int) var damage
export (float) var ignite_tick_rate
export (float) var speed_inc

var ready = true

func _init():
	$Tags.add_tag($Tags.e_effect.health)
	$Tags.add_tag($Tags.e_effect.speed)
	$Tags.add_tag($Tags.e_effect.animation)
	$Tags.add_tag($Tags.e_effect.debuff)
	$Tags.add_tag($Tags.e_effect.init)
	
	
func effekt(value, tag):
	if tag == $Tags.e_effect.init:
		$IgniteTicker.wait_time = ignite_tick_rate
		$IgniteTicker.start()
	if tag == $Tags.e_effect.health:
		if ready:
			ready = false
			$IgniteTicker.start()
			return damage
		return 0
	if tag == $Tags.e_effect.speed:
		return value * speed_inc
	if tag == $Tags.e_effect.animation:
		$Animation.global_position = value.global_position
		$Animation.show()
		$Animation.play("burn")
		return		
	return value
	
func refresh(_obj):	
	if _obj.damage * _obj.ignite_tick_rate  >= damage * ignite_tick_rate:
		damage = _obj.damage
		ignite_tick_rate = _obj.ignite_tick_rate
		set_duration(_obj.duration)

func _on_IgniteTicker_timeout():
	ready = true
