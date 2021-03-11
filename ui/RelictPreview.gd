extends PanelContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_relic_textur(var tex):
	$VBoxContainer/PanelContainer2/TextureRect.texture = tex

func set_relic_name(var name):
	$VBoxContainer/RelictName.text = name

func set_relic_label(var text):
	$VBoxContainer/PanelContainer3/Relict_label.text = text

func reset():
	$VBoxContainer/RelictName.text = name
	$VBoxContainer/PanelContainer2/TextureRect.texture = null
	$VBoxContainer/PanelContainer3/Relict_label.text = ""
