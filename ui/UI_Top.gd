extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_life(var amount):
	$HBoxContainer/Health/HBoxContainer/Amount.text = str(amount)
	
func set_wave(var amount):
	$HBoxContainer/Wave/Label.text = str(amount)
	
func set_gold(var amount):
	$HBoxContainer/Money/HBoxContainer/Amount.text = str(amount)
