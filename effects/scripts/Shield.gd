extends KinematicBody2D

signal health_changed

export (int) var max_health
var health

func take_damage(damage):
	if damage == null:
		return	
	health -= damage
	emit_signal('health_changed',health)
	if health <= 0:
		get_parent().remove_self()

func set_max_health(_max_health):
	max_health = _max_health
	health = _max_health
	emit_signal('health_changed', health)
