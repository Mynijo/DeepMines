extends "res://buildings/Building.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var map

# Called when the node enters the scene tree for the first time.
func _ready():
	map = get_tree().get_root().get_node("map")
	map.add_runes_global(load("res://rune/RuneAddSlow.tscn").instance())


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
