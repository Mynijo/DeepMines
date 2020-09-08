extends Node2D

class class_Inventory:
	var money = 100
	var pickaxe = 100
	var shovel = 100
	var traps = []
	

export (int) var health = 100
export (int) var camera_spped = 500

var selected_trap

var velocity = Vector2(0, 0)

var map

enum e_CURSOR_MODE{
	none,
	Pickaxe,
	Shovel,
	Spillage,
	BuildTrap
}

signal player_take_damage
signal player_took_damage

var Inventory

var current_cursor_mode = e_CURSOR_MODE.none

func _ready():
	map = get_tree().get_root().get_node("map")
	Inventory = class_Inventory.new()
	$UI/Live.text = "Health:" + String(health)
	$UI/Wave.text = "Wave:"
	$UI/Money.text = "Money:" + String(Inventory.money)
	$UI/Pickaxe.text = String(Inventory.pickaxe)
	$UI/Shovel.text  = String(Inventory.shovel)
	
	var relics = []
	relics.append(load("res://relic/Divine_Shield_Relic.tscn").instance())
	relics.append(load("res://relic/Gold_Bars_Relic.tscn").instance())
	relics.append(load("res://relic/BloodyCoin.tscn").instance())
	
	for relic in relics:
		$Relics.add_relic(relic)

	Inventory.traps.append(load("res://buildings/tower/traps/FreezField_Trap.tscn").instance())
	Inventory.traps.append(load("res://buildings/tower/traps/RollingStone_Trap.tscn").instance())
	Inventory.traps.append(load("res://buildings/tower/traps/RollingStone_Trap.tscn").instance())
	Inventory.traps.append(load("res://buildings/tower/traps/RollingStone_Trap.tscn").instance())

func get_selected_trap():
	return selected_trap
	
func remove_trap(_trap):
	Inventory.traps.erase(_trap)
	select_trap()

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
		
func wave_changed(_wave):
	$UI/Wave.text = "Wave:" + String(_wave)

func wave_status(_status):
	$UI/WaveEnd.text = _status

func _physics_process(delta):
	var new_pos = position + velocity * delta * camera_spped
	if(new_pos.y < $Camera.limit_top or new_pos.y >  $Camera.limit_bottom):
		return
	position = new_pos
	
func _on_Area2DTop_mouse_entered():
	velocity += Vector2(0, -1)

func _on_Area2DTop_mouse_exited():
	velocity += Vector2(0, +1)

func _on_Area2DBottom_mouse_entered():
	velocity += Vector2(0, +1)

func _on_Area2DBottom_mouse_exited():
	velocity += Vector2(0, -1)

func _on_Area2DLeft_mouse_entered():
	velocity += Vector2(-1, 0)

func _on_Area2DLeft_mouse_exited():
	velocity += Vector2(1, 0)

func _on_Area2D2Right_mouse_entered():
	velocity += Vector2(1, 0)

func _on_Area2D2Right_mouse_exited():
	velocity += Vector2(-1, 0)

func enable_Mode_Buttons():
	$UI/Cursor_Mode_None.disabled = false
	$UI/Cursor_Mode_Pickaxe.disabled = false
	$UI/Cursor_Mode_Shovel.disabled = false
	$UI/Cursor_Mode_Spillage.disabled = false
	$UI/Cursor_Mode_BuildTrap.disabled = false

func disable_Mode_Buttons():
	$UI/Cursor_Mode_None.disabled = true
	$UI/Cursor_Mode_Pickaxe.disabled = true
	$UI/Cursor_Mode_Shovel.disabled = true
	$UI/Cursor_Mode_Spillage.disabled = true
	$UI/Cursor_Mode_BuildTrap.disabled = true

func _on_Cursor_Mode_None_pressed():
	current_cursor_mode = e_CURSOR_MODE.none
	enable_Mode_Buttons()
	$UI/Cursor_Mode_None.disabled = true

func _on_Cursor_Mode_Pickaxe_pressed():
	current_cursor_mode = e_CURSOR_MODE.Pickaxe
	enable_Mode_Buttons()
	$UI/Cursor_Mode_Pickaxe.disabled = true


func _on_Cursor_Mode_Shovel_pressed():
	current_cursor_mode = e_CURSOR_MODE.Shovel
	enable_Mode_Buttons()
	$UI/Cursor_Mode_Shovel.disabled = true


func _on_Cursor_Mode_Spillage_pressed():
	current_cursor_mode = e_CURSOR_MODE.Spillage
	enable_Mode_Buttons()
	$UI/Cursor_Mode_Spillage.disabled = true


func _on_Cursor_Mode_BuildTrap_pressed():
	current_cursor_mode = e_CURSOR_MODE.BuildTrap
	enable_Mode_Buttons()
	$UI/Cursor_Mode_BuildTrap.disabled = true
	select_trap()

func select_trap():
	if Inventory.traps.empty():
		selected_trap = null
	else:
		selected_trap = Inventory.traps.front()
