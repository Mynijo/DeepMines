extends Node2D


export (Vector2) var size = Vector2(1,1)

export (int) var health = 1000
export (bool) var solid = true

var pos
var cor
var map


func _ready():
	set_map(get_tree().get_root().get_node("Map"))
	pass
	
func set_map(_map):
	map = _map
	
func take_damage(_damage):
	health -= _damage
	if(health <= 0):
		die()


func get_icon():
	return $Sprite.texture

func die():
	pass

func get_size():
	return size
	
func get_solid():
	return solid
	
func set_pos(_pos):
	pos = _pos
	global_position = _pos

func get_pos():
	return pos
	
func set_cor(_cor):
	cor = _cor

func get_cor():
	return cor
	
func calcDmg(_body):
	var dmg = _body.hit_building_get_dmg()
	return dmg
	
func activate_preview():
	pass

func deactivate_preview():
	pass



func _on_Building_body_entered(_body):
	pass # Replace with function body.
