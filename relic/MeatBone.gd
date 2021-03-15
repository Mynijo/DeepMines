extends "res://relic/Relic.gd"

var traps = []

export (int) var amount = 10

# Declare member variables here. Examples:
func _init():
	$Tags.add_tag($Tags.e_relic.game_stat_change)
	
	
func _ready():
	pass # Replace with function body.

	
func call_on_gamestate_changed(var _new_gamestate):
	Player.heal(amount)
	
	
func get_description():
	return "Heal " + str(amount) + " every round"
