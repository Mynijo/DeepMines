extends Node2D


var map
var tower

var open = false

signal gameState_changed

func _ready():
	map = get_tree().get_root().get_node("map")
	tower = get_parent()
	refresh_upgrades()
	Global_GameStateManager.connect("gameState_changed", self, "on_gameState_changed")

func on_gameState_changed(_dummy):
	hide()

func show():
	.show()
	refresh_upgrades()

func refresh_upgrades():
	for child in $HBoxContainer.get_children():
		$HBoxContainer.remove_child(child)
	
	var upgrades = tower.get_possible_upgrades()
	for upgrade in upgrades:
		upgrade.set_tower(tower)
		upgrade.set_UI(self)
		$HBoxContainer.add_child(upgrade)


func _on_Button_pressed():
	hide()
