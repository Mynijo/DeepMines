extends Node2D

export (int) var health = 100
export (int) var money = 120

export (int) var camera_spped = 500

var velocity = Vector2(0, 0)

func _ready():
	$Live.text = "Health:" + String(health)
	$Wave.text = "Wave:"
	$Money.text = "Money:" + String(money)
	
func add_money(value):
	money += value
	$Money.text = "Money:" + String(money)
	
	
func take_damage(damage):
	health -= damage
	$Live.text = "Health:" + String(health)
	if health <= 0:
		pass 

func get_health():
	return health
		
func wave_changed(_wave):
	$Wave.text = "Wave:" + String(_wave)

func wave_status(_status):
	$WaveEnd.text = _status

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
