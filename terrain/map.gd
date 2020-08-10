extends Node2D

var width = 13
var height = 8
var map_as_bi = []


func _init():

	for x in range(width):
		map_as_bi.append([])
		for y in range(height):
			map_as_bi[x].append(false)
	map_as_bi[0][0] = true
	map_as_bi[1][0] = true
	map_as_bi[1][1] = true
	map_as_bi[1][2] = true
	map_as_bi[2][0] = true
	map_as_bi[3][0] = true
	map_as_bi[4][0] = true
	map_as_bi[5][0] = true
	map_as_bi[6][0] = true
	map_as_bi[7][0] = true
	map_as_bi[7][1] = true
	map_as_bi[7][2] = true
	map_as_bi[7][3] = true
	map_as_bi[8][3] = true
	map_as_bi[9][3] = true
	map_as_bi[10][3] = true
	map_as_bi[10][2] = true
	map_as_bi[10][1] = true
	map_as_bi[10][0] = true
	map_as_bi[11][0] = true
	map_as_bi[12][0] = true
	
	map_as_bi[0][7] = true
	map_as_bi[1][7] = true
	map_as_bi[2][7] = true
	map_as_bi[3][7] = true
	map_as_bi[4][7] = true
	map_as_bi[5][7] = true
	map_as_bi[6][7] = true
	map_as_bi[7][7] = true
	map_as_bi[8][7] = true
	map_as_bi[9][7] = true
	map_as_bi[10][7] = true
	map_as_bi[11][7] = true
	map_as_bi[12][7] = true
	
	map_as_bi[0][1] = true
	map_as_bi[0][2] = true
	map_as_bi[0][3] = true
	map_as_bi[0][4] = true
	map_as_bi[0][5] = true
	map_as_bi[0][6] = true

	map_as_bi[12][1] = true
	map_as_bi[12][2] = true
	map_as_bi[12][3] = true
	map_as_bi[12][4] = true
	map_as_bi[12][5] = true
	map_as_bi[12][6] = true
	
	map_as_bi[2][2] = true
	map_as_bi[3][2] = true
	map_as_bi[4][2] = true
	map_as_bi[4][3] = true
	map_as_bi[4][4] = true
	map_as_bi[4][5] = true
	map_as_bi[4][6] = true
	
	map_as_bi[5][2] = true

			
# Called when the node enters the scene tree for the first time.
func _ready():
	var dirt_block = load("res://terrain/blocks/dirt.tscn")
	var air_block = load("res://terrain/blocks/air.tscn")
	var block_inst
	
	for x in range(width):
		map_as_bi.append([])
		for y in range(height):
			if map_as_bi[x][y]:
				block_inst = air_block.instance()
			else:
				block_inst = dirt_block.instance()				
			block_inst.global_position = Vector2(64 * x, 64 * y)
			$blocks.add_child(block_inst)

func get_map_size():
	return Vector2(width, height)

func get_map_as_bi():
	return map_as_bi

func get_root_offset():
	return $blocks.global_position
	
func get_pos_on_map(_cor):
	return _cor * Vector2(64, 64)

func get_pos_on_map_mid(_cor):
	return _cor * Vector2(64, 64) +  get_root_offset()

func get_player():
	return $Player
	
func _on_Tower_shoot(attack, _position, _direction, _tower):
	var bullet = attack
	$NodesTemp.add_child(bullet)
	bullet.start(_position, _direction, _tower)
	
func _on_spawn_rune(rune, _position):
	add_child(rune)
	rune.rect_position = _position
	
func _on_spawn_attack(_attack, _position,_tower):
	add_child(_attack)
	_attack.spwan(_position,_tower)
	
func _on_Spawn_Enemy(_Enemy, _pos):
	$EnemySpawner.add_child(_Enemy)
	_Enemy.add_to_group('enemys')	
	_Enemy.spawn(_pos)
