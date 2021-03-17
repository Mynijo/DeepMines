extends "res://relic/Relic.gd"

export (int) var flat_amount = 0
export (float) var increase_amount = 1.5

# Declare member variables here. Examples:
func _init():
	$Tags.add_tag($Tags.e_relic.pick_up_me)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func call_on_pick_up_me():
	var rune = load("res://rune/RuneIncreasedDamage.tscn").instance()
	rune.increase = increase_amount
	rune.flat = flat_amount
	map.add_runes_global(rune)

func get_description():
	var des = ""
	if increase_amount > 1:
		des = des +"Increase Tower dmg by " + str(100 * increase_amount - 100)
	if flat_amount > 0:
		des = "Add " + str(flat_amount) + "tower flat dmg"
	return des
