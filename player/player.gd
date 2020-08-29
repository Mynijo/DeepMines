extends Node2D

export (int) var health = 100
export (int) var money = 120

export (int) var camera_spped = 500

var velocity = Vector2(0, 0)

var map

enum e_CURSOR_MODE{
	none,
	Pickaxe,
	Shovel,
	Barricade
}

var current_cursor_mode = e_CURSOR_MODE.none

func _ready():
	map = get_tree().get_root().get_node("map")
	$UI/Live.text = "Health:" + String(health)
	$UI/Wave.text = "Wave:"
	$UI/Money.text = "Money:" + String(money)
	
func add_money(value):
	money += value
	$UI/Money.text = "Money:" + String(money)
	
	
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

