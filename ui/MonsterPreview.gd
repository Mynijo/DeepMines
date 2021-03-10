extends PanelContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_Health(var max_Health):
	$VBoxContainer/PanelContainer/CenterContainer/Stats/Health/Label.text = String( max_Health )
func set_Damage(var damage):
	$VBoxContainer/PanelContainer/CenterContainer/Stats/Damage/Label.text = String(damage)
	
func set_Speed(var speed):
	$VBoxContainer/PanelContainer/CenterContainer/Stats/Speed/Label.text = String(round( speed))
	
func set_Reward(var reward):
	$VBoxContainer/PanelContainer/CenterContainer/Stats/Reward/Label.text = String(reward)

func set_Enemy_Textur(var tex):
	$VBoxContainer/PanelContainer/CenterContainer/TextureRect.texture = tex

func set_Enemy_Name(var name):
	$VBoxContainer/MonsterName.text = name

var counter = 0
func set_Status_List(status_list):	
	var first = true
	for status in status_list:
		if status.has_icon():
			var icon = load("res://ui/Effect_Icon.tscn").instance()
			icon.set_preview(self)
			icon.set_effect_text(status.get_effect_text())
			icon.set_texture(status.get_icon().texture)
			$VBoxContainer/PanelContainer2/Effects.add_child(icon)
			if first:
				first = false
				set_effect_text(status.get_effect_text())
	

func reset():
	$VBoxContainer/PanelContainer/CenterContainer/Stats/Health/Label.text = ""
	$VBoxContainer/PanelContainer/CenterContainer/Stats/Damage/Label.text = ""
	$VBoxContainer/PanelContainer/CenterContainer/Stats/Speed/Label.text = ""
	$VBoxContainer/PanelContainer/CenterContainer/Stats/Reward/Label.text = ""
	$VBoxContainer/PanelContainer/CenterContainer/TextureRect.texture = null
	for child in $VBoxContainer/PanelContainer2/Effects.get_children():
		child.free()
		
func set_effect_text(var text):
	$VBoxContainer/PanelContainer3/Effect_label.text = text
