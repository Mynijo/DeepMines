extends "res://relic/Relic.gd"

export (float) var silince_duration = 2
export (int) var silince_chance = 5

# Declare member variables here. Examples:
func _init():
	$Tags.add_tag($Tags.e_relic.pick_up_me)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func call_on_pick_up_me():
	var rune = load("res://rune/RuneSilince.tscn").instance()
	rune.slilince_duration = silince_duration
	rune.silince_chance = silince_chance
	map.add_runes_global(rune)



func get_description():
	var des = "Silince a enemy for " + str(silince_duration)+" seconds at a " + str(silince_chance)+ "% chance "
	return des
