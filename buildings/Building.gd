extends Node2D


export (Vector2) var size

export (int) var health = 1000
export (bool) var solid = true

var pos
var cor
var level_cor
var map


func _ready():
	map = get_tree().get_root().get_node("map")
	
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


func set_cor(_cor, _level_cor):
	cor = _cor
	level_cor = _level_cor

func get_cor():
	return cor

func get_level_cor():
	return level_cor
	
func calcDmg(_body):
	var dmg = _body.hit_building_get_dmg()
	return dmg
