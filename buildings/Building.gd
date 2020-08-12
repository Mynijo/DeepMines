extends Node2D


export (Vector2) var size

export (int) var health = 1000
export (bool) var solid = true

var player
var pos
var cor

func _ready():
	player = get_tree().get_root().get_node("map").get_player()

func take_damage(_damage):
	health -= _damage
	if(health <= 0):
		die()


func die():
	pass

func get_size():
	return size
	
func get_solid():
	return solid
	
func set_pos(_pos):
	pos = _pos
	global_position = _pos


func set_cor(_cor):
	cor = _cor
