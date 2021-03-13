extends "res://effects/scripts/StatusEffect.gd"

export (int) var heal_value
export (float) var tick_rate

var ready = true

func _init():
	$Tags.add_tag($Tags.e_effect.health)
	$Tags.add_tag($Tags.e_effect.buff)
	$Tags.add_tag($Tags.e_effect.init)
	$Tags.add_tag($Tags.e_effect.has_icon)
	
	
func effekt(value, tag):
	if tag == $Tags.e_effect.init:
		$Ticker.wait_time = tick_rate
		$Ticker.start()
		parent = value
	if tag == $Tags.e_effect.health:
		if ready:
			if  parent.health <  parent.max_health:
				ready = false
				$Ticker.start()
				$Ticker.wait_time = tick_rate
				return -heal_value
		return 0
	return value

func _on_Ticker_timeout():
	ready = true

func get_effect_text():
	var text = "Heal " + String(heal_value) + " Every "+ String(tick_rate) + " Sec"
	if duration != 0:
		text = text + " Duration "+ String(duration)
	if $Conditions.get_child_count() > 0:
		for condition in $Conditions.get_children():
			text = text + " "+ condition.get_condition_text()
	return  text

func get_description():
	var des = "Heal by " + str(heal_value)+"hp every " + str(tick_rate)+ " sec"
	return des

