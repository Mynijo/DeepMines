extends "res://effects/scripts/StatusEffect.gd"

export (int) var healValue
export (float) var tick_rate

var ready = true

func _init():
	$Tags.add_tag($Tags.e_effect.health)
	$Tags.add_tag($Tags.e_effect.buff)
	$Tags.add_tag($Tags.e_effect.init)
	
	
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
				return -healValue
		return 0
	return value

func _on_Ticker_timeout():
	ready = true
