extends "res://relic/Relic.gd"




# Declare member variables here. Examples:
func _init():
	$Tags.add_tag($Tags.e_relic.player_took_damage)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func call_on_player_took_damage(_damage):
	if _damage > 0:
		Player.add_money(_damage)
