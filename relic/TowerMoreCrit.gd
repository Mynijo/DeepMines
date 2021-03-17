extends "res://relic/Relic.gd"

export (float) var increase_amount = 0
export (int) var flat_amount = 50

# Declare member variables here. Examples:
func _init():
	$Tags.add_tag($Tags.e_relic.pick_up_me)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func call_on_pick_up_me():
	var rune = load("res://rune/RuneIncreasedCritChance.tscn").instance()
	rune.increase_amount = increase_amount
	rune.flat_amount = flat_amount
	map.add_runes_global(rune)


func get_description():
	var des = ""
	if increase_amount > 1:
		des = des +"Increase Tower chrit chanc by " + str(100 * increase_amount - 100)
	if flat_amount > 0:
		des = "Add " + str(flat_amount) + "% tower chrit chanc"
	return des
