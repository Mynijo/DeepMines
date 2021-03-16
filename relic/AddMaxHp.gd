extends "res://relic/Relic.gd"


export (int) var amount = 30

# Declare member variables here. Examples:
func _init():
	$Tags.add_tag($Tags.e_relic.pick_up_me)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func call_on_pick_up_me():
	Player.max_health = Player.max_health + amount 
	Player.heal(amount)
	
func get_description():
	return "Heal and add " + str(amount) + " max life"
