extends "res://relic/Relic.gd"

export (int) var charges = 3


func _init():
	$Tags.add_tag($Tags.e_relic.player_take_damage)
	$Tags.add_tag($Tags.e_relic.pick_up_me)
	
	
func _ready():
	pass # Replace with function body.


func call_on_pick_up_me():
	change_icon()
	
func change_icon():
	match charges:
		0:
			$Icon.texture = $ChargeOff.texture
		1:
			$Icon.texture = $Charge1.texture
		2:
			$Icon.texture = $Charge2.texture
		_:
			$Icon.texture = $Charge3.texture
	update_icon()

func call_on_player_take_damage(var _player):
	if _player.take_dame > 0:
		_player.take_dame = 0	
		charges -= 1
		change_icon()
		if charges <= 0:
			deactivate()
			
func get_description():
	return "Nullify Player dmg " + str(charges) + " times"
