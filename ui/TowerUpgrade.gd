extends PanelContainer


var rune
var upgrade_name
export (int) var price = 100

var tower
var UI
var cost = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_tower(_tower):
	tower = _tower
	
func set_UI(_UI):
	UI = _UI

func aktivate_me():
	tower.add_rune(rune.duplicate())
	

func _on_TowerUpgrade_gui_input(_event):
	if Global_GameStateManager.game_stat == Global_GameStateManager.e_GAMESTATE.build_phase:
		if _event is InputEventMouseButton and _event.pressed:
			if _event.button_index == BUTTON_LEFT and _event.pressed:
				if Player.get_money() >= cost:
					Player.remove_money(100)
					tower.clear_possible_upgrades()
					aktivate_me()
					UI.hide()

func set_rune(var _rune):
	rune = _rune

func get_Texture():
	return $TowerUpgrade.texture
	
func set_Texture(var _texture):
	$TowerUpgrade.texture = _texture

func get_Price():
	return price
	

func get_Name():
	return upgrade_name
