extends "res://relic/Relic.gd"

export (int) var increase_amount = 1.5

# Declare member variables here. Examples:
func _init():
	$Tags.add_tag($Tags.e_relic.pick_up_me)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func call_on_pick_up_me():
	var rune = load("res://rune/RuneIncreasedAps.tscn").instance()
	rune.increase_amount = increase_amount
	map.add_runes_global(rune)

func get_description():
	return "Increase Tower Attack Speed by " + str(100 * increase_amount - 100) + "%"
