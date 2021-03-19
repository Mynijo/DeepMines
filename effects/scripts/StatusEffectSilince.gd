extends "res://effects/scripts/StatusEffect.gd"

export (float) var silince_duration = 2

var condition = preload("res://effects/conditions/ConditionAfterTime.tscn")

func _init():
	$Tags.add_tag($Tags.e_effect.debuff)
	$Tags.add_tag($Tags.e_effect.init)
	$Tags.add_tag($Tags.e_effect.animation)
	$Tags.add_tag($Tags.e_effect.has_icon)

	
func effekt(value, tag):
	if tag == $Tags.e_effect.init:
		parent = value
		for buff in parent.get_buffs():
			var condition_obj = condition.instance()
			condition_obj.duration = silince_duration
			buff.add_condition(condition_obj)
		
func get_description():
	description = "Deaktivate other buffs for " + str(silince_duration) + " Seconds"
	return description
