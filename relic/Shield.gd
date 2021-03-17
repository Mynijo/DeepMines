extends "res://relic/Relic.gd"

export (int) var dmg_reduction = 1


func _init():
	$Tags.add_tag($Tags.e_relic.player_take_damage)
	
	
func _ready():
	pass # Replace with function body.


func call_on_player_take_damage(var _player):
	if _player.take_dame > dmg_reduction:
		_player.take_dame = _player.take_dame - dmg_reduction
			
func get_description():
	return "Take " + str(dmg_reduction) + " less dmg. But at least " + str(dmg_reduction)
