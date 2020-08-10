extends "res://effects/scripts/StatusEffect.gd"

export (PackedScene) var StatusEffektFreeze

export (float) var SlowRate

var first_time = true
export (float) var freez_chance

func _init():
	$Tags.add_tag($Tags.e_effect.speed)
	$Tags.add_tag($Tags.e_effect.animation)
	$Tags.add_tag($Tags.e_effect.debuff)
	$Tags.add_tag($Tags.e_effect.init)

func effekt(value, tag):
	if tag == $Tags.e_effect.init:
		parent = value
	if tag == $Tags.e_effect.speed:
		if first_time:
			first_time = false
			var counter = 0
			var effects = parent.get_StatusEffects()
			for x in effects:
				if x.name.is_subsequence_of(self.name):
					counter += 1
			if rand_range(0,100) <= (freez_chance + counter*5) and freez_chance > 0:
				parent.add_Status(StatusEffektFreeze.instance())
				for x in effects:
					if x.name.is_subsequence_of(self.name):
						parent.remove_Status(x)
		return value * SlowRate
	var temp =  $Tags.get_tags()
	if tag == $Tags.e_effect.animation:
		$Animation.global_position = value.global_position
		$Animation.show()
		$Animation.play("slow")
		return
		
	return value
	
func refresh(_obj):	
	if _obj.SlowRate >= SlowRate:
		first_time = true
		SlowRate = _obj.SlowRate
		set_duration(_obj.duration)