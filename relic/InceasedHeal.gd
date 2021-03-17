extends "res://relic/Relic.gd"

export (int) var incease = 1.5


func _init():
	$Tags.add_tag($Tags.e_relic.player_take_damage)
	
	
func _ready():
	pass # Replace with function body.


func call_on_player_take_damage(var _player):
	if _player.heal_value > 0:
		_player.heal_value = _player.heal_value * incease
			
func get_description():
	return "Player heal effect is inceased by " + str(100 * incease - 100) + "%"
