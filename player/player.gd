extends Node2D

class class_Inventory:
	var money = 250
	var pickaxe = 10
	var shovel = 5
	var bombs = 10
	var traps = []
	

export (int) var health = 100
export (int) var camera_spped = 500

var selected_trap

var velocity = Vector2(0, 0)

var map

enum e_CURSOR_MODE{
	None,
	Pickaxe,
	Shovel,
	Spillage,
	BuildTrap
}

signal player_take_damage
signal player_took_damage

signal current_cursor_mode_changed

var Inventory

var current_cursor_mode = e_CURSOR_MODE.None

func _ready():
	map = get_tree().get_root().get_node("map")
	Inventory = class_Inventory.new()
	$UI/Live.text = "Health:" + String(health)
	$UI/Wave.text = "Level: 1"
	$UI/Money.text = "Money:" + String(Inventory.money)
	$UI/Control.set_Pickaxes(Inventory.pickaxe)
	$UI/Control.set_Shovels(Inventory.shovel)
	$UI/Control.set_Bombs(Inventory.bombs)
	
	var relics = []
	relics.append(load("res://relic/DivineShieldRelic.tscn").instance())
	#relics.append(load("res://relic/GoldBarsRelic.tscn").instance())
	#relics.append(load("res://relic/BloodyCoin.tscn").instance())
	#relics.append(load("res://relic/BloodDrinker.tscn").instance())
	#relics.append(load("res://relic/BloodDrinker.tscn").instance())
	#relics.append(load("res://relic/BloodDrinker.tscn").instance())
	#relics.append(load("res://relic/BloodDrinker.tscn").instance())
	relics.append(load("res://relic/BloodDrinker.tscn").instance())
	#relics.append(load("res://relic/TrapMaster.tscn").instance())
	
	for relic in relics:
		$UI/Relics.add_relic(relic)

	add_trap(load("res://buildings/tower/traps/PortTrap.tscn").instance())
	add_trap(load("res://buildings/tower/traps/FreezFieldTrap.tscn").instance())
	add_trap(load("res://buildings/tower/traps/RollingStoneTrap.tscn").instance())
	add_trap(load("res://buildings/tower/traps/RollingStoneTrap.tscn").instance())
	add_trap(load("res://buildings/tower/traps/RollingStoneTrap.tscn").instance())

func add_trap(var trap):
	Inventory.traps.append(trap)	
	if selected_trap == null:
		set_selected_trap(trap)
		
func get_traps():
	return Inventory.traps

func _unhandled_key_input(event):
	velocity = Vector2(0, 0)
	if(Input.is_action_pressed("move_left")):
		velocity += Vector2(-1, 0)
	if(Input.is_action_pressed("move_right")):
		velocity += Vector2(1, 0)
	if(Input.is_action_pressed("move_up")):
		velocity += Vector2(0, -1)
	if(Input.is_action_pressed("move_down")):
		velocity += Vector2(0, +1)
			
	if(Input.is_action_pressed("change_cursor_mode_none")):
		change_Cursor_Mode(e_CURSOR_MODE.None)
	if(Input.is_action_pressed("change_cursor_mode_pickaxe")):
		change_Cursor_Mode(e_CURSOR_MODE.Pickaxe)
	if(Input.is_action_pressed("change_cursor_mode_shovel")):
		change_Cursor_Mode(e_CURSOR_MODE.Shovel)
	if(Input.is_action_pressed("change_cursor_mode_spillage")):
		change_Cursor_Mode(e_CURSOR_MODE.Spillage)

func set_new_wave_counter(_wave):
	$UI/Wave.text = "Level: " + String(_wave)

func get_selected_trap():
	return selected_trap
	
func remove_trap(_trap):
	Inventory.traps.erase(_trap)
	if _trap == get_selected_trap():
		if not get_traps().empty():
			set_selected_trap(get_traps()[0])
		else:
			set_selected_trap(null)

func add_bombs(_bombs):
	Inventory.bombs += _bombs
	$UI/Control.set_Bombs(Inventory.bombs)
	
func remove_bombs(_bombs):
	if Inventory.bombs - _bombs < 0:
		Inventory.bombs = 0
	else:
		Inventory.bombs -= _bombs
	$UI/Control.set_Bombs(Inventory.bombs)

func get_bombs():
	return Inventory.bombs

func add_pickaxe(_pickaxe):
	Inventory.pickaxe += _pickaxe
	$UI/Control.set_Pickaxes(Inventory.pickaxe)
	
func remove_pickaxe(_pickaxe):
	if Inventory.pickaxe - _pickaxe < 0:
		Inventory.pickaxe = 0
	else:
		Inventory.pickaxe -= _pickaxe
	$UI/Control.set_Pickaxes(Inventory.pickaxe)

func get_pickaxe():
	return Inventory.pickaxe
	
func add_shovel(_shovel):
	Inventory.shovel += _shovel
	$UI/Control.set_Shovels(Inventory.shovel)
	
func remove_shovel(_shovel):
	if Inventory.shovel - _shovel < 0:
		Inventory.shovel = 0
	else:
		Inventory.shovel -= _shovel
	$UI/Control.set_Shovels(Inventory.shovel)
	
func get_shovel():
	return Inventory.shovel
	
func add_money(value):
	Inventory.money += value
	$UI/Money.text = "Money:" + String(Inventory.money)

func remove_money(value):
	Inventory.money -= value
	$UI/Money.text = "Money:" + String(Inventory.money)

func get_money():
	return Inventory.money

var take_dame = 0
func take_damage(_damage):
	take_dame = _damage
	emit_signal('player_take_damage', self)
	health -= take_dame
	$UI/Live.text = "Health:" + String(health)
	if health <= 0:
		pass 
	emit_signal('player_took_damage', take_dame)

func get_health():
	return health
	
func heal(value):
	health += value
	$UI/Live.text = "Health:" + String(health)

func wave_changed(_wave):
	$UI/Wave.text = "Wave:" + String(_wave)

func wave_status(_status):
	$UI/WaveEnd.text = _status

func _physics_process(delta):
	var new_pos = position + velocity * delta * camera_spped
	if(new_pos.y < $Camera.limit_top or new_pos.y >  $Camera.limit_bottom):
		return
	position = new_pos
	$UI/Pos.text = str($Camera.get_global_mouse_position())
	
func _on_Area2DTop_mouse_entered():
	velocity += Vector2(0, -1)

func _on_Area2DTop_mouse_exited():
	velocity = Vector2(0, 0)

func _on_Area2DBottom_mouse_entered():
	velocity += Vector2(0, +1)

func _on_Area2DBottom_mouse_exited():
	velocity = Vector2(0, 0)

func _on_Area2DLeft_mouse_entered():
	velocity += Vector2(-1, 0)

func _on_Area2DLeft_mouse_exited():
	velocity = Vector2(0, 0)

func _on_Area2D2Right_mouse_entered():
	velocity += Vector2(1, 0)

func _on_Area2D2Right_mouse_exited():
	velocity = Vector2(0, 0)

func change_Cursor_Mode(var mode):
	current_cursor_mode = mode
	emit_signal('current_cursor_mode_changed')
	$UI/Preview.hide()
	$UI/RelictPreview.hide()
	$UI/Control.close_trap_chooser()
	$UI/Control.hilight_button(mode)
	
func _on_Cursor_Mode_BuildTrap_pressed():
	change_Cursor_Mode(e_CURSOR_MODE.BuildTrap)



func set_selected_trap(var trap):		
	selected_trap = trap
	$UI/Control.selected_trap_changed()

func enable_Mode_Buttons():
	$UI/Control.show()
	$UI/Buy_Pickaxe.show()
	$UI/Buy_Bombs.show()
	$UI/Buy_Shovel.show()
	
func disable_Mode_Buttons():
	$UI/Control.hide()
	$UI/Buy_Pickaxe.hide()
	$UI/Buy_Bombs.hide()
	$UI/Buy_Shovel.hide()

func _on_Buy_Pickaxe_pressed():
	if Player.get_money() >= 5:
		Player.remove_money(5)
		Player.add_pickaxe(1)


func _on_Buy_Shovel_pressed():
	if Player.get_money() >= 10:
		Player.remove_money(10)
		Player.add_shovel(1)


func _on_Buy_Bombs_pressed():
	if Player.get_money() >= 5:
		Player.remove_money(5)
		Player.add_bombs(1)

func show_Preview(var name, var max_Health, var damage, var speed, var reward, var tex, var status_list):
	$UI/RelictPreview.hide()
	$UI/Preview.reset()
	$UI/Preview.set_Health(max_Health)
	$UI/Preview.set_Damage(damage)
	$UI/Preview.set_Speed(speed)
	$UI/Preview.set_Reward(reward)
	$UI/Preview.set_Enemy_Textur(tex)	
	$UI/Preview.set_Enemy_Name(name)	
	$UI/Preview.set_Status_List(status_list)
	$UI/Preview.show()

func show_relic_preview(var name, var tex, var status_text):
	$UI/Preview.hide()
	$UI/RelictPreview.reset()
	$UI/RelictPreview.set_relic_textur(tex)	
	$UI/RelictPreview.set_relic_name(name)	
	$UI/RelictPreview.set_relic_label(status_text)
	$UI/RelictPreview.show()


func _on_Area2D_input_event(viewport, _event, shape_idx):
	if _event is InputEventMouseButton and _event.pressed:
		if _event.button_index == BUTTON_RIGHT and _event.pressed:
			change_Cursor_Mode(e_CURSOR_MODE.None)

var debug_counter = 0
func add_debug(var text):
	$UI/Debug.text =  String($UI/Debug.text) + "\n"+ String(debug_counter) + ": "+ String(text)
	debug_counter = debug_counter + 1
	$UI/Debug.scroll_following = true


var speed_auto_stop = false
func set_game_speed(var speed):
	speed_auto_stop = false
	$UI/HBoxContainer/Label.text = "Now: "+ str(speed)
	Engine.set_time_scale(speed)

func _on_GameSpeed1_pressed():
	set_game_speed(1)

func _on_GameSpeed2_Stop_pressed():
	set_game_speed(2)
	speed_auto_stop = true

func _enemy_dmg_taken():
	if speed_auto_stop:
		set_game_speed(1)
	
func _on_Tower_shoot(attack, _position, _direction, _tower):
	if speed_auto_stop:
		set_game_speed(1)
