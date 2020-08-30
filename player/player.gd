extends Node2D

class class_Inventory:
	var money = 100
	var pickaxe = 100
	var shovel = 100
	
	

export (int) var health = 100
export (int) var camera_spped = 500


var velocity = Vector2(0, 0)

var map

enum e_CURSOR_MODE{
	none,
	Pickaxe,
	Shovel,
	Barricade
}

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
	Inventory.shovel + _shovel
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
	
	
func take_damage(damage):
	health -= damage
	$UI/Live.text = "Health:" + String(health)
	if health <= 0:
		pass 

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
	$UI/Cursor_Mode_Barricade.disabled = false

func disable_Mode_Buttons():
	$UI/Cursor_Mode_None.disabled = true
	$UI/Cursor_Mode_Pickaxe.disabled = true
	$UI/Cursor_Mode_Shovel.disabled = true
	$UI/Cursor_Mode_Barricade.disabled = true

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


func _on_Cursor_Mode_Barricade_pressed():
	current_cursor_mode = e_CURSOR_MODE.Barricade
	enable_Mode_Buttons()
	$UI/Cursor_Mode_Barricade.disabled = true

