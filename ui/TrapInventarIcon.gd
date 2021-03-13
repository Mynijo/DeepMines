extends PanelContainer

var trap
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_trap(var _trap):
	trap = _trap

func set_icon(var tex):
	$TextureButton.texture_normal = tex


func _on_TextureButton_pressed():
	Player.set_selected_trap(trap)
	Player.change_Cursor_Mode(Player.e_CURSOR_MODE.BuildTrap)
