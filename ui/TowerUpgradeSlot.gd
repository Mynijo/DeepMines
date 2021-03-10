extends HBoxContainer


func _ready():
	pass # Replace with function body.


func set_Textur(var textur):	
	$PanelContainer/VBoxContainer/TowerUpgrade.set_Texture(textur)
	
func set_tower(tower):
	$PanelContainer/VBoxContainer/TowerUpgrade.set_tower(tower)
	
func set_UI(ui):
	$PanelContainer/VBoxContainer/TowerUpgrade.set_UI(ui)
	
func set_rune(_rune):
	$PanelContainer/VBoxContainer/TowerUpgrade.set_rune(_rune)
	set_Textur(_rune.get_Icon().texture)
	set_Price(_rune.get_Price())
	set_Name(_rune.get_Name())
	
func set_Price(var price):
	$PanelContainer/VBoxContainer/Name.text = String(price)
	

func set_Name(var name):
	$PanelContainer/VBoxContainer/Name.text = name
	
