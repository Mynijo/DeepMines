extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_Pickaxes(value):
	$VBoxContainer/Pickaxes/TextureButtonPickaxes/Amount.text = str(value)
	
func set_Shovels(value):
	$VBoxContainer/Shovels/TextureButtonShovels/Amount.text = str(value)
	
func set_Bombs(value):
	$VBoxContainer/Bombs/TextureButtonBombs/Amount.text = str(value)

func hilight_button(var mode):
	relase_buttons()
	if mode == Player.e_CURSOR_MODE.Pickaxe:
		$VBoxContainer/Pickaxes/TextureButtonPickaxes/TextureRect_selceted.show()
	if mode == Player.e_CURSOR_MODE.Shovel:
		$VBoxContainer/Shovels/TextureButtonShovels/TextureRect_selceted.show()
	if mode == Player.e_CURSOR_MODE.Bomb:
		$VBoxContainer/Bombs/TextureButtonBombs/TextureRect_selceted.show()
	if mode == Player.e_CURSOR_MODE.BuildTrap:
		$VBoxContainer/HBoxContainer/Traps/TextureButton/TextureRect_selceted.show()
		
func _on_TextureButtonPickaxes_pressed():
	Player.change_Cursor_Mode(Player.e_CURSOR_MODE.Pickaxe)	

func _on_TextureButtonShovels_pressed():
	Player.change_Cursor_Mode(Player.e_CURSOR_MODE.Shovel)

func _on_TextureButtonBombs_pressed():
	Player.change_Cursor_Mode(Player.e_CURSOR_MODE.Bomb)

func _on_TextureButton_pressed():
	Player.change_Cursor_Mode(Player.e_CURSOR_MODE.BuildTrap)
	
func relase_buttons():
	$VBoxContainer/Pickaxes/TextureButtonPickaxes/TextureRect_selceted.hide()
	$VBoxContainer/Shovels/TextureButtonShovels/TextureRect_selceted.hide()
	$VBoxContainer/Bombs/TextureButtonBombs/TextureRect_selceted.hide()
	$VBoxContainer/HBoxContainer/Traps/TextureButton/TextureRect_selceted.hide()

func _on_Spacer_pressed():
	open_trap_chooser()

func open_trap_chooser():
	$VBoxContainer/HBoxContainer/Spacer.hide()
	$VBoxContainer/HBoxContainer/Grid.show()
	for child in $VBoxContainer/HBoxContainer/Grid.get_children():
		child.queue_free()
	
	for trap in Player.get_traps():
		var trap_icon = load("res://ui/TrapInventarIcon.tscn").instance()
		trap_icon.set_icon(trap.get_icon().duplicate())
		trap_icon.set_trap(trap)
		$VBoxContainer/HBoxContainer/Grid.add_child(trap_icon)
	
func close_trap_chooser():
	$VBoxContainer/HBoxContainer/Spacer.show()
	$VBoxContainer/HBoxContainer/Grid.hide()

func selected_trap_changed():
	var trap =  Player.get_selected_trap()
	if trap != null:
		$VBoxContainer/HBoxContainer/Traps/TextureButton/TextureRect_empty.hide()
		$VBoxContainer/HBoxContainer/Traps/TextureButton.texture_normal = trap.get_icon().duplicate()
	else:
		$VBoxContainer/HBoxContainer/Traps/TextureButton/TextureRect_empty.show()


