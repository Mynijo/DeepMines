extends "res://relic/Relic.gd"

export (int) var port_chance = 5

# Declare member variables here. Examples:
func _init():
	$Tags.add_tag($Tags.e_relic.pick_up_me)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func call_on_pick_up_me():
	var rune = load("res://rune/RunePortChance.tscn").instance()
	rune.port_chance = port_chance
	map.add_runes_global(rune)

func get_description():
	return "Tower have a " + str(port_chance) + "% chance to port the enemy to his startpoint"
