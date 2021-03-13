extends PanelContainer


var trap
var relict

var price

# Called when the node enters the scene tree for the first time.
func _ready():
	pass 
	

func _exit_tree():
	if trap:
		trap.free()
	if relict:
		relict.free()

func set_name(var name):
	$VBoxContainer/Name.text = name

func set_prics(var prics):
	$VBoxContainer/HBoxContainer/Price.text = str(prics)
	
func set_texture(var texture):
	$VBoxContainer/PanelContainer/TextureButton.texture_normal = texture
	

func set_trap(var _trap):
	trap = _trap
	set_name(trap.get_name())
	set_texture(trap.get_icon().duplicate())
	price = trap.get_price()
	set_prics(price)
	
func set_relict(var _relict):
	relict = _relict
	set_name(relict.get_name())
	set_texture(relict.get_icon().texture)
	price = relict.get_price() + (randi() % relict.get_price())
	set_prics(price)


func _on_TextureButton2_pressed():
	if relict:
		Player.show_relic_preview(relict.get_name(),relict.get_icon().texture, relict.get_description())
	if trap:
		Player.show_relic_preview(trap.get_name(),trap.get_icon().duplicate(), trap.get_description())


func _on_TextureButton_pressed():
	if Player.get_money() >= price:
		Player.remove_money(price)
	else:
		return
		
	if relict:
		Player.add_relict(relict)
	if trap:
		Player.add_trap(trap)
	$VBoxContainer/PanelContainer/TextureButton.disabled = true
