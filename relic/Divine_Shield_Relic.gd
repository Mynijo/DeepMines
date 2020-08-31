extends "res://relic/Relic.gd"

export (int) var charges = 1

func _init():
	$Tags.add_tag($Tags.e_relic.player_take_damage)
	
func _ready():
	pass # Replace with function body.


func call_on_player_take_damage(var _player):
	_player.take_dame = 0	
	charges -= 1	
	if charges <= 0:
		deactivate()
