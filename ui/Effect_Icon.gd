extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Preview
var effect_text

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_preview(var _preview):
	Preview = _preview

func set_texture(var tex):
	self.texture = tex

func _on_Effect_Icon_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT and event.pressed:
			Preview.set_effect_text(get_effect_text())
			

func set_effect_text(var text):
	effect_text = text

func get_effect_text():
	return effect_text
