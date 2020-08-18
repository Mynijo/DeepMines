extends Node2D


var map_size = Vector2(20, 20)
var width
var height
var map_as_bi = {}

var block_size_pix = Vector2(40,40)

var heart
var astar


var levels = []

enum e_GAMESTATE{
	none,
	build_phase,
	battel_phase
}


signal Runes_Changed

var game_stat = e_GAMESTATE.none

func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	gen_level(Vector2(0,0))
	ini_astar()
	fill_blocks(Vector2(0,0))
	
func add_heart():
	if heart == null:
		heart = load("res://buildings/player_buildings/Dungeon_Heart.tscn").instance()
		add_building(heart, Vector2(9,0),  Vector2(0,0))
		
func change_game_state(var _new_stat):
	if game_stat == _new_stat:
		return
	game_stat = _new_stat
	match game_stat:
		e_GAMESTATE.battel_phase:
			hide_gen_buttons()
		e_GAMESTATE.build_phase:
			show_gen_buttons()

func fill_blocks(_level_cor):
	var dirt_block = load("res://terrain/blocks/Dirt.tscn")
	var air_block = load("res://terrain/blocks/Air.tscn")
	var block_inst
	var map_as_bi_lvl = map_as_bi[String(level_cor_to_id(_level_cor))]
	for x in range(width):
		map_as_bi_lvl.append([])
		for y in range(height):
			if map_as_bi_lvl[x][y]:
				block_inst = air_block.instance()
			else:
				block_inst = dirt_block.instance()
			$blocks.add_child(block_inst)
			block_inst.global_position = get_pos_on_map_mid(Vector2(x,y), _level_cor)
			


func get_map_size():
	return Vector2(width, height)

func get_map_as_bi():
	return map_as_bi

func get_root_offset():
	return $blocks.global_position
	
func get_pos_on_map_mid(_cor, _level_cor):
	return _cor * block_size_pix +  get_root_offset() + (_level_cor*block_size_pix*map_size)

func get_player():
	return $Player
	
func get_heart():
	add_heart()
	return heart
	
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
	
var enemys = []
func _on_Spawn_Enemy(_Enemy, _pos, _cor, _level_cor):
	$enemys.add_child(_Enemy)
	enemys.append(_Enemy)
	_Enemy.spawn(_pos, _cor, _level_cor)
	change_game_state(e_GAMESTATE.battel_phase)

func remove_enemy(_enemy):
	enemys.erase(_enemy)
	if enemys.empty():
		change_game_state(e_GAMESTATE.build_phase)
	
	
func _on_Spawn_Building(_building, _cor, _level_cor):
	add_building(_building, _cor, _level_cor)
	
	
func add_building(_building, _cor, _level_cor):
	var size = _building.get_size()
	var temp_pos = get_pos_on_map_mid(_cor, _level_cor) + (((size - Vector2(1,1)) * (block_size_pix /2)))
	_building.set_pos(temp_pos)
	_building.set_cor(_cor, _level_cor)
	$buildings.add_child(_building)
	
func get_astar():
	return astar


func ini_astar():
	astar = AStar.new()
	if astar == null:
		astar = AStar.new()
	else:
		astar.clear()
	add_level_to_astar(Vector2(0,0))

func add_level_to_astar(_level_cor):
	for x in range(map_size.x):
		for y in range(map_size.y):
			astar.add_point(astar.get_available_point_id(), Vector3(x, y, level_cor_to_id(_level_cor)))
		
	var map_as_bi_lvl = map_as_bi[String(level_cor_to_id(_level_cor))]
	for x in range(map_size.x):
		for y in range(map_size.y):
			if map_as_bi_lvl[x][y]:
				if x -1 >= 0:
					if map_as_bi_lvl[x -1][y]:
						var point1 = astar.get_closest_point(Vector3(   x, y, level_cor_to_id(_level_cor)))
						var point2 = astar.get_closest_point(Vector3(x -1, y, level_cor_to_id(_level_cor)))
						astar.connect_points(point1, point2, true)
				if y -1 >= 0:
					if map_as_bi_lvl[x][y -1]:
						var point1 = astar.get_closest_point(Vector3( x, y  , level_cor_to_id(_level_cor)))
						var point2 = astar.get_closest_point(Vector3( x, y -1, level_cor_to_id(_level_cor)))
						astar.connect_points(point1, point2, true)
						
	if map_as_bi.has(String(level_cor_to_id(_level_cor + Vector2(1,0)))):
		var neighbour = map_as_bi[String(level_cor_to_id(_level_cor + Vector2(1,0)))]
		for y in range(map_size.y):
			if map_as_bi_lvl[map_size.x -1][y] && neighbour[0][y]:
					var point1 = astar.get_closest_point(Vector3(map_size.x -1, y, level_cor_to_id(_level_cor)))
					var point2 = astar.get_closest_point(Vector3(            0, y, level_cor_to_id(_level_cor+ Vector2(1,0))))
					astar.connect_points(point1, point2, true)
					
	if map_as_bi.has(String(level_cor_to_id(_level_cor + Vector2(-1,0)))):
		var neighbour = map_as_bi[String(level_cor_to_id(_level_cor + Vector2(-1,0)))]
		for y in range(map_size.y):
			if map_as_bi_lvl[0][y] && neighbour[map_size.x -1][y]:
					var point1 = astar.get_closest_point(Vector3(             0, y, level_cor_to_id(_level_cor)))
					var point2 = astar.get_closest_point(Vector3( map_size.x -1, y, level_cor_to_id(_level_cor+ Vector2(-1,0))))
					astar.connect_points(point1, point2, true)

	if map_as_bi.has(String(level_cor_to_id(_level_cor + Vector2(0,1)))):
		var neighbour = map_as_bi[String(level_cor_to_id(_level_cor + Vector2(0,1)))]
		for x in range(map_size.x):
			if map_as_bi_lvl[x][map_size.y -1] && neighbour[x][0]:
					var point1 = astar.get_closest_point(Vector3( x, map_size.y -1, level_cor_to_id(_level_cor)))
					var point2 = astar.get_closest_point(Vector3( x,             0, level_cor_to_id(_level_cor+ Vector2(0,1))))
					astar.connect_points(point1, point2, true)

	if map_as_bi.has(String(level_cor_to_id(_level_cor + Vector2(0,-1)))):
		var neighbour = map_as_bi[String(level_cor_to_id(_level_cor + Vector2(0,-1)))]
		for x in range(map_size.x):
			if map_as_bi_lvl[x][0] && neighbour[x][map_size.y -1]:
					var point1 = astar.get_closest_point(Vector3( x,             0, level_cor_to_id(_level_cor)))
					var point2 = astar.get_closest_point(Vector3( x, map_size.y -1, level_cor_to_id(_level_cor+ Vector2(0,-1))))
					astar.connect_points(point1, point2, true)

var runes_per_level = {}
var runes_global = []

func get_Tower_Runes(var _level_id):
	var run = []
	if runes_per_level.has (String(_level_id)):
		for r in runes_per_level[String(_level_id)]:
			run.append(r)
	for r in runes_global:
		run.append(r)
	return run
	
func add_runes_global( _rune):
	runes_global.append(_rune)
	emit_signal('Runes_Changed')
	
func add_runes_per_level(_level_id, _rune):
	if runes_per_level.has (String(_level_id)):
		runes_per_level[String(_level_id)].append(_rune)
	else:
		runes_per_level[String(_level_id)] = []
		runes_per_level[String(_level_id)].append(_rune)
	emit_signal('Runes_Changed')	
		
	
func id_to_level_cor(_id):
	var x = (int(_id) % 1000000) 
	if x != 0:
		x -=  1000
	var y = stepify((_id +1000)/1000000, 1)
	return Vector2(x, y)
	

func level_cor_to_id(_level_cor):
	return _level_cor.y * 1000000 + (_level_cor.x +1000)
	
	
func level_id_to_floor_number(_ebene):
	var i = 0	
	for lvl in levels:
		i += 1
		if lvl == _ebene:
			return i
	return -1

func gen_level(_level_cor):
	levels.append(_level_cor)
	if _level_cor == Vector2(0,0):
		add_heart()
	gen_empty_lvl(_level_cor)
	

func gen_empty_lvl(_level_cor):
	if map_as_bi.has(String(level_cor_to_id(_level_cor))):
		return
	width = map_size.x
	height = map_size.y
	map_as_bi[String(level_cor_to_id(_level_cor))] = []
	map_as_bi[String(level_cor_to_id(_level_cor))].clear()
	var map_as_bi_lvl = map_as_bi[String(level_cor_to_id(_level_cor))]
	
	for x in range(width):
		map_as_bi_lvl.append([])
		for y in range(height):
			map_as_bi_lvl[x].append(true)
	add_buildings_level(_level_cor)

func add_buildings_level(_level_cor):
	var rand_pos =  Vector2(randi() % int(map_size.x), randi() % int(map_size.y))	
	if _level_cor == Vector2(0,0):
		rand_pos =  Vector2(2,8)
		
	var base1 = load("res://buildings/spawner/Enemy_Base_Small.tscn").instance()
	add_building(base1,rand_pos , _level_cor)
	base1.spawn_enemys(level_id_to_floor_number(_level_cor))
	var tf = load("res://buildings/player_buildings/Tower_Foundation.tscn")
	base1.add_spawn_on_kill(tf.instance())
	
	rand_pos =  Vector2(randi() % int(map_size.x), randi() % int(map_size.y))
	if _level_cor == Vector2(0,0):
		rand_pos =  Vector2(8,16)
	
	var base2 = load("res://buildings/spawner/Enemy_Base_Small.tscn").instance()
	add_building(base2, rand_pos, _level_cor)
	base2.spawn_enemys(level_id_to_floor_number(_level_cor))
	base2.add_spawn_on_kill(tf.instance())	
	
	rand_pos =  Vector2(0, 0)
	if _level_cor == Vector2(0,1):
		var baseb = load("res://buildings/spawner/Enemy_Base_Big.tscn").instance()
		tf = load("res://buildings/Runen_Tower.tscn")
		add_building(baseb, rand_pos, _level_cor)
		baseb.spawn_enemys(level_id_to_floor_number(_level_cor))
		baseb.add_spawn_on_kill(tf.instance())

func show_gen_buttons():
	var new_level
	new_level = levels.back() + Vector2(-1,0)
	if levels.find(new_level) == -1:
		var pos =  get_pos_on_map_mid(Vector2(0,int((map_size.y -1) / 2)), levels.back())
		$Buttons/Gen_Level_Left.set_global_position(pos)
		$Buttons/Gen_Level_Left.disabled = false
		$Buttons/Gen_Level_Left.visible = true
		
	new_level = levels.back() + Vector2(0,1)
	if levels.find(new_level) == -1:
		var pos =  get_pos_on_map_mid(Vector2(int((map_size.x -1) / 2),int((map_size.y -1))), levels.back())
		$Buttons/Gen_Level_Down.set_global_position(pos)
		$Buttons/Gen_Level_Down.disabled = false
		$Buttons/Gen_Level_Down.visible = true
		
	new_level = levels.back() + Vector2(1,0)
	if levels.find(new_level) == -1:
		var pos =  get_pos_on_map_mid(Vector2(map_size.x -1,int((map_size.y -1) / 2)), levels.back())
		$Buttons/Gen_Level_Right.set_global_position(pos)
		$Buttons/Gen_Level_Right.disabled = false
		$Buttons/Gen_Level_Right.visible = true
	
	
func hide_gen_buttons():
	$Buttons/Gen_Level_Left.disabled = true
	$Buttons/Gen_Level_Left.visible = false
	$Buttons/Gen_Level_Down.disabled = true
	$Buttons/Gen_Level_Down.visible = false
	$Buttons/Gen_Level_Right.disabled = true
	$Buttons/Gen_Level_Right.visible = false
	

func _on_Gen_Level_Left_pressed():
	var next_level = levels.back() + Vector2(-1,0)
	gen_level(next_level)
	fill_blocks(next_level)
	add_level_to_astar(next_level)


func _on_Gen_Level_Down_pressed():
	var next_level = levels.back() + Vector2(0,1)
	gen_level(next_level)
	fill_blocks(next_level)
	add_level_to_astar(next_level)


func _on_Gen_Level_Right_pressed():
	var next_level = levels.back() + Vector2(1,0)
	gen_level(next_level)
	fill_blocks(next_level)
	add_level_to_astar(next_level)
