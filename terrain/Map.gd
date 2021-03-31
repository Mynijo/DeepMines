extends Node2D

var map_tile_size = Vector2(9, 9)
var max_levels = 10

var heart_cor

var block_size_pix = Vector2(64,64)

var levels = []
var level_entries = {}

signal Runes_Changed

enum e_leveltype {
	e_heart,
	e_normal,
	e_shop
}

var EnemyBase = "res://buildings/spawner/EnemyBaseSmall.tscn"
var TowerFoundation = "res://buildings/playerBuildings/TowerFoundation.tscn"
var DungeonHeart = "res://buildings/playerBuildings/DungeonHeart.tscn"

var leveltype_list = {
	e_leveltype.e_heart  : [[DungeonHeart, Vector2(4,1)], [TowerFoundation, Vector2(2,6)], [TowerFoundation, Vector2(6,6)]],
	e_leveltype.e_normal : [[EnemyBase], [EnemyBase]],
	e_leveltype.e_shop   : [["res://buildings/playerBuildings/TowerFoundation.tscn"]],
#	"biome"    : [],
#	"rune"     : [], # big enemy spawner for rune field and 2 enemy spawner for normal tower
#	"tower"    : [["res://buildings/playerBuildings/TowerFoundation.tscn"], ["res://buildings/playerBuildings/TowerFoundation.tscn"], ["res://buildings/playerBuildings/TowerFoundation.tscn"]], #3x tower type
#	"event"    : [], # not implemented yet, no towers
#	"fountain" : [], # choose heal or gold
#	"treasure" : [],  # hidden room
#	"boss"     : [],  
}
enum e_Blocks {
	e_Dirt,
	e_Floor,
	e_Pit,
	e_Buliding_solid,
	e_Buliding_free
}

var block_typs ={
	e_Blocks.e_Dirt : {mineable = true, buildable = false, walkable = false, digable = false, bombable = false},
	e_Blocks.e_Floor : {mineable = false, buildable = true, walkable = true, digable = true, bombable = true},
	e_Blocks.e_Pit : {mineable = false, buildable = false, walkable = false, digable = false, bombable = true},
	e_Blocks.e_Buliding_solid : {mineable = false, buildable = false, walkable = false, digable = false, bombable = false},
	e_Blocks.e_Buliding_free : {mineable = false, buildable = false, walkable = true, digable = false, bombable = false}
}

func _init():
	Global_AStar.set_map(self)
	Global_AStar.set_map_size(map_tile_size)
	var _rc
	_rc = rand_seed(420)
	randomize ( )
	
func set_heart_cor(cor):
	heart_cor = cor
	
func get_heart_cor():
	return heart_cor


# Called when the node enters the scene tree for the first time.
func _ready():
	Global_AStar.ini_astar()
	
	gen_full_map()
	
	gen_level(Vector2(0, 0), e_leveltype.e_heart)
	#gen_level(Vector2(0, 1), "normal")
	#gen_level(Vector2(1, 0), "normal")
	#gen_level(Vector2(1, 1), "normal")

	Global_GameStateManager.change_game_state(Global_GameStateManager.e_GAMESTATE.build_phase)
	
func get_unique_rand_pos(used_pos, _level_cor):
	var pos = Vector2(randi() % int(map_tile_size.x -4) + 2, randi() % int(map_tile_size.y -4) + 2)
	pos = pos + _level_cor * map_tile_size
	if used_pos.has(pos):
		return get_unique_rand_pos(used_pos, _level_cor)
	return pos
			

func gen_full_map():
	for x in range(-map_tile_size.x * (max_levels -1) -5, map_tile_size.x * max_levels +5):
		for y in range(-5, map_tile_size.y * (max_levels) +5):
			$TileMap.set_cell(x, y, 0, false, false,false,Vector2(9,2))
	#set_level_type
	for x in range(-max_levels +1, max_levels):
		for y in range(max_levels):
			if x != 0 or y != 0:
				var level_preview_obj = load("res://ui/Level_preview.tscn").instance()
				$LevelPreviews.add_child(level_preview_obj)
				var pos_x = x * block_size_pix.x * map_tile_size.x
				var pos_y = y * block_size_pix.y * map_tile_size.y
				level_preview_obj.position = Vector2(pos_x, pos_y)
				level_preview_obj.set_button_size(block_size_pix * map_tile_size)
				level_preview_obj.set_level_type(get_random_level_type())
				level_preview_obj.set_level_cor(Vector2(x,y))
			

func get_random_level_type():
	return randi() % 2 + 1

func update_level_previews(_level_cor):
	for preview in $LevelPreviews.get_children():
		if preview.level_cor == _level_cor + Vector2(-1,0) or preview.level_cor == _level_cor + Vector2(1,0) or preview.level_cor == _level_cor + Vector2(0,1):
			preview.enabel()
		else:
			preview.disabel()
			

func gen_level(_level_cor, _leveltype):
	
	update_level_previews(_level_cor)
	
	var leveltype = leveltype_list[_leveltype]
	fill_level(_level_cor)
	var used_pos = []
	levels.append(_level_cor)
	var buildings = []
	
	var level_cor_start = get_global_cor(Vector2(0, 0), _level_cor)
	var level_cor_end   = get_global_cor(map_tile_size, _level_cor) - Vector2(1, 1)
	
	for buidling in leveltype:
		var cor
		if buidling.size() >= 2:
			cor = get_global_cor(buidling[1], _level_cor)
		else:
			cor = get_unique_rand_pos(used_pos, _level_cor)
		var building_obj =  load(buidling[0]).instance()
		add_building(building_obj, cor)
		used_pos.append(cor)
		buildings.append(building_obj)
		
	var rand_left
	if level_entries.has(String(level_cor_to_id(_level_cor + Vector2(-1, 0)))):
		rand_left = Vector2(level_cor_start.x, level_entries[String(level_cor_to_id(_level_cor + Vector2(-1, 0)))].y)
	else:
		rand_left = Vector2(level_cor_start.x, get_random_pos(_level_cor, 1).y)
	used_pos.append(rand_left)

	# Check if there's a level to the right
	var rand_right
	if level_entries.has(String(level_cor_to_id(_level_cor + Vector2(1, 0)))):
		rand_right = Vector2(level_cor_end.x, level_entries[String(level_cor_to_id(_level_cor + Vector2(1, 0)))].x)
	else:
		rand_right = Vector2(level_cor_end.x, get_random_pos(_level_cor, 1).y)
	used_pos.append(rand_right)
	
	var rand_bot = Vector2(randi() % int(map_tile_size.x-2) +1, map_tile_size.y - 1)
	rand_bot = Vector2(get_random_pos(_level_cor, 1).x, level_cor_end.y)
	used_pos.append(rand_bot)

	level_entries[String(level_cor_to_id(_level_cor))] = Vector3(rand_left.y, rand_right.y, rand_bot.x)

	# If level above exists, add a connection
	var rand_top
	if level_entries.has(String(level_cor_to_id(_level_cor + Vector2(0, -1)))):
		rand_top = Vector2(level_entries[String(level_cor_to_id(_level_cor + Vector2(0, -1)))].z, level_cor_start.y)
		used_pos.append(rand_top)

	# run astar
	# Run random weighted AStar for each edge in MST
	var astar = AStar.new()

	var count = 0
	for x in range(level_cor_start.x , level_cor_end.x +1):
		for y in range(level_cor_start.y , level_cor_end.y +1):
			var temp_id = gen_lvl_cor_to_id(Vector2(x, y))
			astar.add_point(temp_id, Vector3(x, y, 0), rand_range(10, 11000))
			count = count + 1
	
	count = 0
	for x in range(level_cor_start.x , level_cor_end.x +1):
		for y in range(level_cor_start.y , level_cor_end.y +1):
			if (is_cor_in_map(Vector2(x, y), _level_cor) or used_pos.has(Vector2(x, y))):
				if(is_cor_in_map(Vector2(x-1, y), _level_cor) or used_pos.has(Vector2(x-1, y))):
					connect_via_cor(Vector2(x, y), Vector2(x -1, y), astar)
					count = count + 1
			if (is_cor_in_map(Vector2(x, y), _level_cor) or used_pos.has(Vector2(x, y))):
				if (is_cor_in_map(Vector2(x, y-1), _level_cor) or used_pos.has(Vector2(x, y-1))):
					connect_via_cor(Vector2(x, y), Vector2(x, y- 1), astar)
					count = count + 1
							
	
	# Shuffle positions and connect them
	for index in range(used_pos.size() - 1):
		var point1 = gen_lvl_cor_to_id(used_pos[index])
		var point2 = gen_lvl_cor_to_id(used_pos[index + 1])
		for id in astar.get_id_path(point1, point2):
			$TileMap.set_cellv(gen_lvl_id_to_cor(id), 1)
	
	# Set each field around the buildings to air
	for building in buildings:
		var building_pos = building.get_cor()
		for _x in range(building_pos.x - 1, building_pos.x + 2):
			for _y in range(building_pos.y - 1, building_pos.y + 2):
				if is_cor_in_map(Vector2(_x, _y), _level_cor):
					$TileMap.set_cellv(Vector2(_x, _y), 1)
					
	for building in buildings:
		if building.get_solid():
			$TileMap.set_cellv(building.get_cor(), 3)
		else:
			$TileMap.set_cellv(building.get_cor(), 4)
	
	update_level(_level_cor)
	Player.set_new_wave_counter(levels.size())
	Global_AStar.add_level_to_astar(_level_cor)
	
	
	
func connect_via_cor(cor1, cor2, astar):
	var point1 = gen_lvl_cor_to_id(cor1)
	var point2 = gen_lvl_cor_to_id(cor2)
	astar.connect_points(point1, point2, true)

func get_random_pos(_level_cor, border = 0):
	var rand_x = randi() % int(map_tile_size.x - 2*border) +border + map_tile_size.x * _level_cor.x
	var rand_y = randi() % int(map_tile_size.y - 2*border) +border + map_tile_size.y * _level_cor.y
	return Vector2(rand_x, rand_y)

func is_cor_in_map(_cor, _level_cor):
	var local_cor = get_local_cor(_cor, _level_cor)
	return local_cor.x > 0 and local_cor.y > 0 and local_cor.x < map_tile_size.x-1 and local_cor.y < map_tile_size.y-1


func gen_lvl_id_to_cor(_id):
	var id = _id
	var x = (int(id) % 100000) - 10000
	var y = stepify(id /100000, 1)
	return Vector2(x, y)

func gen_lvl_cor_to_id(_level_cor): #
	var id = _level_cor.y * 100000 + _level_cor.x + 10000
	return id
		
func fill_level(_level_cor):
	var min_ = get_global_cor(Vector2(0,0), _level_cor)
	var max_ = get_global_cor(map_tile_size, _level_cor)
	
	for x in range(min_.x, max_.x):
		for y in range(min_.y, max_.y):
			$TileMap.set_cell(x, y, 0)
	
func update_level(_level_cor):
	var min_ = get_global_cor(Vector2(0,0), _level_cor)
	var max_ = get_global_cor(map_tile_size, _level_cor)	
	$TileMap.update_bitmask_region(min_,max_)

func add_building(_building, _cor):
	var size = _building.get_size()
	var temp_pos = get_pos_on_map_mid(_cor) + (((size - Vector2(1,1)) * (block_size_pix /2)))
	_building.set_map(self)
	_building.set_pos(temp_pos)
	_building.set_cor(_cor)
	$Buildings.add_child(_building)
	if _building.get_solid():
		$TileMap.set_cellv(_cor, 3)
	else:
		$TileMap.set_cellv(_cor, 4)

func get_pos_on_map_mid(_cor):
	return (_cor * block_size_pix) + get_root_offset() + (block_size_pix /2)

func get_global_cor(_cor, _level_cor):
	return _cor + _level_cor *  map_tile_size
	
func get_local_cor(_cor, _level_cor):
	return _cor - _level_cor *  map_tile_size
	
func get_root_offset():
	return $TileMap.global_position

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
	
	
var enemy_effects_per_level = {}
var enemy_effects_global = []

func get_enemy_effects(var _level_id):
	var eff = []
	if enemy_effects_per_level.has (String(_level_id)):
		for r in enemy_effects_per_level[String(_level_id)]:
			eff.append(r)
	for r in enemy_effects_global:
		eff.append(r)
	return eff

func add_enemy_effect_global( _effect):
	enemy_effects_global.append(_effect)

func add_enemy_effect_per_level(_level_id, _effect):
	if enemy_effects_per_level.has (String(_level_id)):
		enemy_effects_per_level[String(_level_id)].append(_effect)
	else:
		enemy_effects_per_level[String(_level_id)] = []
		enemy_effects_per_level[String(_level_id)].append(_effect)


func level_id_to_floor_number(_ebene):
	var i = 0
	for lvl in levels:
		i += 1
		if lvl == _ebene:
			return i
	return -1

func get_TileMap():
	return $TileMap

func level_cor_to_id(_level_cor):
	return _level_cor.y * 1000000 + (_level_cor.x +1000)

func is_current_entry(cor):
	var _level_cor = levels.back()
	var level_cor_start = get_global_cor(Vector2(0, 0), _level_cor)
	var level_cor_end   = get_global_cor(map_tile_size, _level_cor) - Vector2(1, 1)
	
	var left = Vector2(level_cor_start.x, level_entries[String(level_cor_to_id(_level_cor))].x)
	var right = Vector2(level_cor_end.x, level_entries[String(level_cor_to_id(_level_cor))].y)
	var bot = Vector2(level_entries[String(level_cor_to_id(_level_cor))].z, level_cor_end.y)
	
	
	if not level_entries.has(String(level_cor_to_id(_level_cor + Vector2(1, 0)))):
		if right == cor:
			return true
	if not level_entries.has(String(level_cor_to_id(_level_cor + Vector2(-1, 0)))):
		if left == cor:
			return true
	if bot == cor:
		return true
	return false

var enemys = []
func _on_Spawn_Enemy(_Enemy, _pos, _cor):
	var temp_pos = get_pos_on_map_mid(_cor)
	$enemys.add_child(_Enemy)
	enemys.append(_Enemy)
	_Enemy.spawn(temp_pos, _cor)
	Global_GameStateManager.change_game_state(Global_GameStateManager.e_GAMESTATE.battle_phase)

func remove_enemy(_enemy):
	enemys.erase(_enemy)
	if enemys.empty():
		Global_GameStateManager.change_game_state(Global_GameStateManager.e_GAMESTATE.build_phase)

func _on_Tower_shoot(attack, _position, _direction, _tower):
	var bullet = attack
	$NodesTemp.add_child(bullet)
	bullet.start(_position, _direction, _tower)

func _on_spawn_attack(_attack, _position,_tower):
	add_child(_attack)
	_attack.spwan(_position,_tower)
