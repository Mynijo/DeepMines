extends Node2D

var map_tile_size = Vector2(11, 11)

var block_size_pix = Vector2(48,48)

var levels = []
var level_entries = {}

signal Runes_Changed

var leveltype_list = {
	"normal"   : [["res://buildings/playerBuildings/TowerFoundation.tscn"], ["res://buildings/playerBuildings/TowerFoundation.tscn"]],
	"heart"    : [["res://buildings/playerBuildings/DungeonHeart.tscn", Vector2(5,1)], ["res://buildings/playerBuildings/TowerFoundation.tscn", Vector2(2,6)], ["res://buildings/playerBuildings/TowerFoundation.tscn", Vector2(8,6)]],
	"shop"     : [], # no towers
	"biome"    : [],
	"rune"     : [], # big enemy spawner for rune field and 2 enemy spawner for normal tower
	"tower"    : [["res://buildings/playerBuildings/TowerFoundation.tscn"], ["res://buildings/playerBuildings/TowerFoundation.tscn"], ["res://buildings/playerBuildings/TowerFoundation.tscn"]], #3x tower type
	"event"    : [], # not implemented yet, no towers
	"fountain" : [], # choose heal or gold
	"treasure" : [],  # hidden room
	"boss"     : [],  
}


func _init():
	Global_AStar.set_map_size(map_tile_size)
	var _rc
	_rc = rand_seed(420)
	randomize ( )
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	gen_level(Vector2(0, 0), leveltype_list["heart"])
	#gen_level(Vector2(0, 1), leveltype_list["normal"])
	#gen_level(Vector2(1, 0), leveltype_list["normal"])
	#gen_level(Vector2(1, 1), leveltype_list["normal"])
	
	Global_GameStateManager.change_game_state(Global_GameStateManager.e_GAMESTATE.build_phase)
	
func get_new_rand_pos(used_pos):
	var pos = Vector2(randi() % int(map_tile_size.x -4) + 2, randi() % int(map_tile_size.y -4) + 2)
	if used_pos.has(pos) or not is_cor_in_map(pos):
		return get_new_rand_pos(used_pos)
	return pos
			


func gen_level(_level_cor, leveltype):
	fill_level(_level_cor)
	var used_pos = []
	levels.append(_level_cor)
	var buildings_pos = []
	
	for buidling in leveltype:
		var pos
		if buidling.size() >= 2:
			pos = buidling[1]
		else:
			pos = get_new_rand_pos(used_pos)
		var building_obj =  load(buidling[0]).instance()
		add_building(building_obj, pos, _level_cor)
		used_pos.append(pos)
		buildings_pos.append(pos)
		
	var rand_left
	if level_entries.has(String(Global_AStar.level_cor_to_id(_level_cor + Vector2(-1, 0)))):
		rand_left = Vector2(0, level_entries[String(Global_AStar.level_cor_to_id(_level_cor + Vector2(-1, 0)))].y)
	else:
		rand_left = Vector2(0, randi() % int(map_tile_size.y -2) +1)
		while(used_pos.find(rand_left) != -1):
			rand_left =  Vector2(map_tile_size.x - 1, randi() % int(map_tile_size.y-2) +1)
	used_pos.append(rand_left)

	# Check if there's a level to the right
	var rand_right
	if level_entries.has(String(Global_AStar.level_cor_to_id(_level_cor + Vector2(1, 0)))):
		rand_right = Vector2(map_tile_size.x - 1, level_entries[String(Global_AStar.level_cor_to_id(_level_cor + Vector2(1, 0)))].x)
	else:
		rand_right = Vector2(map_tile_size.x - 1, randi() % int(map_tile_size.y-2) +1)
		while(used_pos.find(rand_right) != -1):
			rand_right =  Vector2(map_tile_size.x - 1, randi() % int(map_tile_size.y-2) +1)
	used_pos.append(rand_right)

	var rand_bot = Vector2(randi() % int(map_tile_size.x-2) +1, map_tile_size.y - 1)
	while(used_pos.find(rand_bot) != -1):
		rand_bot =  Vector2(randi() % int(map_tile_size.x-2) +1, map_tile_size.y - 1)
	used_pos.append(rand_bot)

	level_entries[String(Global_AStar.level_cor_to_id(_level_cor))] = Vector3(rand_left.y, rand_right.y, rand_bot.x)

	# If level above exists, add a connection
	if level_entries.has(String(Global_AStar.level_cor_to_id(_level_cor + Vector2(0, -1)))):
		used_pos.append(Vector2(level_entries[String(Global_AStar.level_cor_to_id(_level_cor + Vector2(0, -1)))].z, 0))

	# run astar
	# Run random weighted AStar for each edge in MST
	var astar = AStar.new()
	for x in range(map_tile_size.x):
		for y in range(map_tile_size.y):			
			var temp_id = gen_lvl_cor_to_id(Vector2(x, y))
			astar.add_point(temp_id, Vector3(x, y, 0), rand_range(10, 11000))

	print(used_pos)
	for x in range(map_tile_size.x):
		for y in range(map_tile_size.y):				
			if x -1 >= 0:
				if (used_pos.has(Vector2(x, y)) or is_cor_in_map(Vector2(x, y))) and (used_pos.has(Vector2(x-1, y)) or is_cor_in_map(Vector2(x-1, y))):
					var point1 = gen_lvl_cor_to_id(Vector2(x, y))
					var point2 = gen_lvl_cor_to_id(Vector2(x - 1, y))
					astar.connect_points(point1, point2, true)
			if y -1 >= 0:
				if (used_pos.has(Vector2(x, y)) or is_cor_in_map(Vector2(x, y))) and (used_pos.has(Vector2(x, y-1)) or is_cor_in_map(Vector2(x, y-1))):
					var point1 = gen_lvl_cor_to_id(Vector2(x, y))
					var point2 = gen_lvl_cor_to_id(Vector2(x, y - 1))
					astar.connect_points(point1, point2, true)
				
				
	# Shuffle positions and connect them
	used_pos.shuffle()
	for index in range(used_pos.size() - 1):
		var point1 = gen_lvl_cor_to_id(used_pos[index])
		var point2 = gen_lvl_cor_to_id(used_pos[index + 1])
		for id in astar.get_id_path(point1, point2):
			var temp_cor =  get_global_cor(gen_lvl_id_to_cor(id), _level_cor)
			$TileMap.set_cell(temp_cor.x, temp_cor.y, 1)
	
	# Set each field around the buildings to air
	for building_pos in buildings_pos:
		for _x in range(building_pos.x - 1, building_pos.x + 2):
			for _y in range(building_pos.y - 1, building_pos.y + 2):
				if is_cor_in_map(Vector2(_x, _y)):
					var temp_cor = get_global_cor(Vector2(_x, _y), _level_cor)
					$TileMap.set_cell(temp_cor.x, temp_cor.y, 1)
	
	update_level(_level_cor)
	Player.set_new_wave_counter(levels.size())
	



func is_cor_in_map(_cor):
	return _cor.x > 0 and _cor.y > 0 and _cor.x < map_tile_size.x-1 and _cor.y < map_tile_size.y-1


func gen_lvl_id_to_cor(_id):
	var x = (int(_id) % 10000)
	var y = stepify(_id /10000, 1)
	return Vector2(x, y)

func gen_lvl_cor_to_id(_level_cor):
	return _level_cor.y * 10000 + _level_cor.x
		
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

func add_building(_building, _cor, _level_cor):
	var size = _building.get_size()
	var temp_pos = get_pos_on_map_mid(_cor, _level_cor) + (block_size_pix /2) + (((size - Vector2(1,1)) * (block_size_pix /2)))
	$Buildings.add_child(_building)
	_building.set_pos(temp_pos)
	_building.set_cor(_cor, _level_cor)
	var temp_cor = get_global_cor(_cor, _level_cor)
	$TileMap.set_cell(temp_cor.x, temp_cor.y, 1)

func get_pos_on_map_mid(_cor, _level_cor):
	return (_cor * block_size_pix) + (_level_cor*block_size_pix*map_tile_size) + get_root_offset()

func get_global_cor(_cor, _level_cor):
	return _cor + _level_cor *  map_tile_size
	
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
