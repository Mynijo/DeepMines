extends HBoxContainer


func _ready():
	pass # Replace with function body.


func set_Upgrade(var upgrade):	
	$PanelContainer/VBoxContainer.add_child(upgrade)
	$PanelContainer/VBoxContainer.move_child(upgrade, 0)
	set_Price(upgrade.get_Price())
	set_Name(upgrade.get_Name())
	
	
func set_Price(var price):
	$PanelContainer/VBoxContainer/Name.text = String(price)
	

func set_Name(var name):
	$PanelContainer/VBoxContainer/Name.text = name
	
