extends "res://relic/Relic.gd"


# Declare member variables here. Examples:
func _init():
	$Tags.add_tag($Tags.e_relic.pick_up_me)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func call_on_pick_up_me():
	map.add_enemy_effect_global(load("res://effects/StatusEffectHealPlayOnDeath.tscn").instance())
