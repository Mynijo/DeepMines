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

var Inventory

var current_cursor_mode = e_CURSOR_MODE.None

func _ready():
	map = get_tree().get_root().get_node("map")
	Inventory = class_Inventory.new()
	$UI/Live.text = "Health:" + String(health)
	$UI/Wave.text = "Level: 1"
	$UI/Money.text = "Money:" + String(Inventory.money)
	$UI/Pickaxe.text = String(Inventory.pickaxe)
	$UI/Shovel.text  = String(Inventory.shovel)
	$UI/Bombs.text  = String(Inventory.bombs)
	
	var relics = []
	#relics.append(load("res://relic/DivineShieldRelic.tscn").instance())
	#relics.append(load("res://relic/GoldBarsRelic.tscn").instance())
	#relics.append(load("res://relic/BloodyCoin.tscn").instance())
	#relics.append(load("res://relic/BloodDrinker.tscn").instance())
	#relics.append(load("res://relic/TrapMaster.tscn").instance())
	
	for relic in relics:
		$Relics.add_relic(relic)

	Inventory.traps.append(load("res://buildings/tower/traps/PortTrap.tscn").instance())
	Inventory.traps.append(load("res://buildings/tower/traps/FreezFieldTrap.tscn").instance())
	Inventory.traps.append(load("res://buildings/tower/traps/RollingStoneTrap.tscn").instance())
	Inventory.traps.append(load("res://buildings/tower/traps/RollingStoneTrap.tscn").instance())
	Inventory.traps.append(load("res://buildings/tower/traps/RollingStoneTrap.tscn").instance())
	_on_Cursor_Mode_BuildTrap_UP_pressed()


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
	_on_Cursor_Mode_BuildTrap_UP_pressed()

func add_bombs(_bombs):
	Inventory.bombs += _bombs
	$UI/Bombs.text = String(Inventory.bombs)
	
func remove_bombs(_bombs):
	if Inventory.bombs - _bombs < 0:
		Inventory.bombs = 0
	else:
		Inventory.bombs -= _bombs
	$UI/Bombs.text = String(Inventory.bombs)

func get_bombs():
	return Inventory.bombs

func add_pickaxe(_pickaxe):
	Inventory.pickaxe += _pickaxe
	$UI/Pickaxe.text = String(Inventory.pickaxe)
	
func remove_pickaxe(_pickaxe):
	if Inventory.pickaxe - _pickaxe < 0:
		Inventory.pickaxe = 0
	else:
		Inventory.pickaxe -= _pickaxe
	$UI/Pickaxe.text = String(Inventory.pickaxe)

func get_pickaxe():
	return Inventory.pickaxe
	
func add_shovel(_shovel):
	Inventory.shovel += _shovel
	$UI/Shovel.text  = String(Inventory.shovel)
	
func remove_shovel(_shovel):
	if Inventory.shovel - _shovel < 0:
		Inventory.shovel = 0
	else:
		Inventory.shovel -= _shovel
	$UI/Shovel.text  = String(Inventory.shovel)
	
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

func enable_Mode_Buttons():
	$UI/Cursor_Mode_None.disabled = false
	$UI/Cursor_Mode_Pickaxe.disabled = false
	$UI/Cursor_Mode_Shovel.disabled = false
	$UI/Cursor_Mode_Spillage.disabled = false
	$UI/Cursor_Mode_BuildTrap.disabled = false
	$UI/Buy_Pickaxe.disabled = false
	$UI/Buy_Shovel.disabled = false
	$UI/Buy_Bombs.disabled = false

func disable_Mode_Buttons():
	$UI/Cursor_Mode_None.disabled = true
	$UI/Cursor_Mode_Pickaxe.disabled = true
	$UI/Cursor_Mode_Shovel.disabled = true
	$UI/Cursor_Mode_Spillage.disabled = true
	$UI/Cursor_Mode_BuildTrap.disabled = true
	$UI/Buy_Pickaxe.disabled = true
	$UI/Buy_Shovel.disabled = true
	$UI/Buy_Bombs.disabled = true
	
func change_Cursor_Mode(var mode):
	current_cursor_mode = mode
	enable_Mode_Buttons()
	if(mode == e_CURSOR_MODE.None):
		$UI/Cursor_Mode_None.disabled = true
	else:
		$UI/Cursor_Mode_None.disabled = false
		
	if(mode == e_CURSOR_MODE.Pickaxe):
		$UI/Cursor_Mode_Pickaxe.disabled = true
	if(mode == e_CURSOR_MODE.Shovel):
		$UI/Cursor_Mode_Shovel.disabled = true
	if(mode == e_CURSOR_MODE.Spillage):
		$UI/Cursor_Mode_Spillage.disabled = true
	if(mode == e_CURSOR_MODE.BuildTrap):
		$UI/Cursor_Mode_BuildTrap.disabled = true

func _on_Cursor_Mode_None_pressed():
	change_Cursor_Mode(e_CURSOR_MODE.None)
	

func _on_Cursor_Mode_Pickaxe_pressed():
	change_Cursor_Mode(e_CURSOR_MODE.Pickaxe)


func _on_Cursor_Mode_Shovel_pressed():
	change_Cursor_Mode(e_CURSOR_MODE.Shovel)


func _on_Cursor_Mode_Spillage_pressed():
	change_Cursor_Mode(e_CURSOR_MODE.Spillage)


func _on_Cursor_Mode_BuildTrap_pressed():
	change_Cursor_Mode(e_CURSOR_MODE.BuildTrap)


func _on_Cursor_Mode_BuildTrap_UP_pressed():
	if not Inventory.traps.empty():
		var selected_trap_id = Inventory.traps.find(selected_trap)
		if Inventory.traps.size() > selected_trap_id +1:
			selected_trap = Inventory.traps[selected_trap_id +1]
		else:
			selected_trap = Inventory.traps[0]
		$UI/Cursor_Mode_BuildTrap.icon = selected_trap.get_icon().duplicate()
	else:
		selected_trap = null
		$UI/Cursor_Mode_BuildTrap.icon = null


func _on_Cursor_Mode_BuildTrap_DOWN_pressed():
	if not Inventory.traps.empty():
		var selected_trap_id = Inventory.traps.find(selected_trap)
		if Inventory.traps.size() > selected_trap_id -1:
			selected_trap = Inventory.traps[selected_trap_id -1]
		else:
			selected_trap = Inventory.traps[Inventory.traps.size() -1]
		$UI/Cursor_Mode_BuildTrap.icon = selected_trap.get_icon().duplicate()
	else:
		selected_trap = null
		$UI/Cursor_Mode_BuildTrap.icon = null


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
