extends Node2D


var map_size = Vector2(10, 10)
var width
var height

var block_size_pix = Vector2(40,40)

var heart


var levels = []

var level_entries = {}


enum e_LEVELTYPE {
	none,
	heart,
	shop, # no towers
	biome,
	rune, # big enemy spawner for rune field and 2 enemy spawner for normal tower
	tower, #3x tower type
	event, # not implemented yet, no towers
	fountain, # choose heal or gold
	treasure, # hidden room
	boss
}

var map_as_bi = {}


signal Runes_Changed


func _init():
	Global_AStar.set_map_size(map_size)
	var _rc
	_rc = rand_seed(420)
	randomize ( )

# Called when the node enters the scene tree for the first time.
func _ready():
	gen_level(Vector2(0,0))
	fill_blocks(Vector2(0,0))
	Global_AStar.ini_astar()
	Global_GameStateManager.change_game_state(Global_GameStateManager.e_GAMESTATE.build_phase)


	#var buff = load("res://effects/StatusEffectSelfPort.tscn").instance()
	#add_enemy_effect_per_level(Global_AStar.level_cor_to_id(Vector2(0,1)), buff)


func add_heart(var _heart_cor, var _level_cor):
	if heart == null:
		heart = load("res://buildings/player_buildings/Dungeon_Heart.tscn").instance()
		add_building(heart, _heart_cor,  _level_cor)
		Global_AStar.set_heart(_heart_cor, _level_cor)



func fill_blocks(_level_cor):
	var dirt_block = load("res://terrain/blocks/dirt.tscn")
	var air_block = load("res://terrain/blocks/air.tscn")
	var pit_block = load("res://terrain/blocks/pit.tscn")
	var none_block = load("res://terrain/blocks/none.tscn")
	var built_on_air = load("res://terrain/blocks/built_on_air.tscn")
	var block_inst
	var map_as_bi_lvl = map_as_bi[String(Global_AStar.level_cor_to_id(_level_cor))]
	Global_AStar.map_level_block[String(Global_AStar.level_cor_to_id(_level_cor))] = []
	var map_level = Global_AStar.map_level_block[String(Global_AStar.level_cor_to_id(_level_cor))]
	for x in range(map_size.x):
		map_level.append([])
		for y in range(map_size.y):
			if map_as_bi_lvl[x][y] == Global_Block.e_BLOCKS.dirt:
				block_inst = dirt_block.instance()
			else: if map_as_bi_lvl[x][y] == Global_Block.e_BLOCKS.air:
				block_inst = air_block.instance()
			else: if map_as_bi_lvl[x][y] == Global_Block.e_BLOCKS.none:
				block_inst = none_block.instance()
			else: if map_as_bi_lvl[x][y] == Global_Block.e_BLOCKS.pit:
				block_inst = pit_block.instance()
			else: if map_as_bi_lvl[x][y] == Global_Block.e_BLOCKS.built_on_air:
				block_inst = built_on_air.instance()

			$blocks.add_child(block_inst)
			block_inst.set_pos(Vector2(x,y) ,_level_cor,get_pos_on_map_mid(Vector2(x,y), _level_cor))
			map_level[x].append(block_inst)


func replace_block(var _block, var _newBlock):
	$blocks.add_child(_newBlock)
	_newBlock.set_pos(_block.Cor, _block.Level_cor, _block.global_position)
	$blocks.remove_child(_block)

	var map_as_bi_lvl = map_as_bi[String(Global_AStar.level_cor_to_id(_newBlock.Level_cor))]
	map_as_bi_lvl[_newBlock.Cor.x][_newBlock.Cor.y] = _newBlock.BlockType

	var map_level = Global_AStar.map_level_block[String(Global_AStar.level_cor_to_id(_newBlock.Level_cor))]
	map_level[_newBlock.Cor.x][_newBlock.Cor.y] = _newBlock
	Global_AStar.recalc(_newBlock.Cor, _newBlock.Level_cor)




func get_map_size():
	return Vector2(width, height)


func get_root_offset():
	return $blocks.global_position

func get_pos_on_map_mid(_cor, _level_cor):
	return (_cor * block_size_pix) + (_level_cor*block_size_pix*map_size) +  get_root_offset()

func get_heart():
	add_heart(Vector2(9, 0), Vector2(0, 0))
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
	Global_GameStateManager.change_game_state(Global_GameStateManager.e_GAMESTATE.battle_phase)

func remove_enemy(_enemy):
	enemys.erase(_enemy)
	if enemys.empty():
		Global_GameStateManager.change_game_state(Global_GameStateManager.e_GAMESTATE.build_phase)


func _on_Spawn_Building(_building, _cor, _level_cor):
	add_building(_building, _cor, _level_cor)


func add_building(_building, _cor, _level_cor):
	var size = _building.get_size()
	var temp_pos = get_pos_on_map_mid(_cor, _level_cor) + (((size - Vector2(1,1)) * (block_size_pix /2)))
	$buildings.add_child(_building)
	_building.set_pos(temp_pos)
	_building.set_cor(_cor, _level_cor)

	if !map_as_bi.has(String(Global_AStar.level_cor_to_id(_level_cor))):
		return


	for x in range(_cor.x, _cor.x + size.x):
		for y in range(_cor.y, _cor.y + size.y):
			var levle_cor = String(Global_AStar.level_cor_to_id(_level_cor))
			if Global_AStar.map_level_block.has(levle_cor):
				var map_level = Global_AStar.map_level_block[levle_cor]
				var block = map_level[x][y]
				if !_building.solid:
					replace_block(block, load("res://terrain/blocks/built_on_air.tscn").instance())
				else:
					replace_block(block, load("res://terrain/blocks/None.tscn").instance())
				block.queue_free()
			else:
				var level = map_as_bi[String(levle_cor)]
				if !_building.solid:
					level[x][y] = Global_Block.e_BLOCKS.built_on_air
				else:
					level[x][y] = Global_Block.e_BLOCKS.none


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
	
func get_last_level():
	return levels.back()
	
func get_blocks():
	return $blocks.get_children()

#func gen_level(_level_cor):
#	levels.append(_level_cor)
#	gen_empty_lvl(_level_cor)
#	if _level_cor == Vector2(0,0):
#		add_heart()
#	add_buildings_level(_level_cor)

func gen_lvl_cor_to_id(_level_cor):
	return _level_cor.y * 10000 + _level_cor.x

func gen_lvl_id_to_cor(_id):
	var x = (int(_id) % 10000)
	var y = stepify(_id /10000, 1)
	return Vector2(x, y)

func is_cor_in_map(_cor):
	return _cor.x >= 0 and _cor.y >= 0 and _cor.x < map_size.x and _cor.y < map_size.y

func gen_level(_level_cor):
	var used_pos = []
	levels.append(_level_cor)
	if _level_cor == Vector2(0,0):
		var heart_pos = Vector2(9, 0)
		add_heart(heart_pos, Vector2(0, 0))
		used_pos.append(heart_pos)
		used_pos.append(heart_pos + Vector2(0, 1))
		used_pos.append(heart_pos + Vector2(1, 1))
		used_pos.append(heart_pos + Vector2(1, 0))

	# Check if there's a level to the left
	var rand_left
	if level_entries.has(String(Global_AStar.level_cor_to_id(_level_cor + Vector2(-1, 0)))):
		rand_left = Vector2(0, level_entries[String(Global_AStar.level_cor_to_id(_level_cor + Vector2(-1, 0)))].y)
	else:
		rand_left = Vector2(0, randi() % int(map_size.y))
		while(used_pos.find(rand_left) != -1):
			rand_left =  Vector2(map_size.x - 1, randi() % int(map_size.y))
	used_pos.append(rand_left)

	# Check if there's a level to the right
	var rand_right
	if level_entries.has(String(Global_AStar.level_cor_to_id(_level_cor + Vector2(1, 0)))):
		rand_right = Vector2(map_size.x - 1, level_entries[String(Global_AStar.level_cor_to_id(_level_cor + Vector2(1, 0)))].x)
	else:
		rand_right = Vector2(map_size.x - 1, randi() % int(map_size.y))
		while(used_pos.find(rand_right) != -1):
			rand_right =  Vector2(map_size.x - 1, randi() % int(map_size.y))
	used_pos.append(rand_right)

	var rand_bot = Vector2(randi() % int(map_size.x), map_size.y - 1)
	while(used_pos.find(rand_bot) != -1):
		rand_bot =  Vector2(randi() % int(map_size.x), map_size.y - 1)
	used_pos.append(rand_bot)

	# Generate two random unequal postions for buildings
	var rand_pos =  Vector2(randi() % int(map_size.x), randi() % int(map_size.y))
	while(used_pos.find(rand_pos) != -1):
		rand_pos =  Vector2(randi() % int(map_size.x), randi() % int(map_size.y))
	used_pos.append(rand_pos)

	var rand_pos_2 =  Vector2(randi() % int(map_size.x), randi() % int(map_size.y))
	while(used_pos.find(rand_pos_2) != -1):
		rand_pos_2 =  Vector2(randi() % int(map_size.x), randi() % int(map_size.y))
	used_pos.append(rand_pos_2)

	level_entries[String(Global_AStar.level_cor_to_id(_level_cor))] = Vector3(rand_left.y, rand_right.y, rand_bot.x)

	# If level above exists, add a connection
	if level_entries.has(String(Global_AStar.level_cor_to_id(_level_cor + Vector2(0, -1)))):
		used_pos.append(Vector2(level_entries[String(Global_AStar.level_cor_to_id(_level_cor + Vector2(0, -1)))].z, 0))

	# run astar
	# Run random weighted AStar for each edge in MST
	var astar = AStar.new()
	for x in range(map_size.x):
		for y in range(map_size.y):
			var temp_id = gen_lvl_cor_to_id(Vector2(x, y))
			astar.add_point(temp_id, Vector3(x, y, 0), rand_range(10, 11000))

	for x in range(map_size.x):
		for y in range(map_size.y):
			if x -1 >= 0:
				var point1 = gen_lvl_cor_to_id(Vector2(x, y))
				var point2 = gen_lvl_cor_to_id(Vector2(x - 1, y))
				astar.connect_points(point1, point2, true)
			if y -1 >= 0:
				var point1 = gen_lvl_cor_to_id(Vector2(x, y))
				var point2 = gen_lvl_cor_to_id(Vector2(x, y - 1))
				astar.connect_points(point1, point2, true)

	# Fill whole level with dirt
	map_as_bi[String(Global_AStar.level_cor_to_id(_level_cor))] = []
	map_as_bi[String(Global_AStar.level_cor_to_id(_level_cor))].clear()
	var map_as_bi_lvl = map_as_bi[String(Global_AStar.level_cor_to_id(_level_cor))]

	for _x in range(map_size.x):
		map_as_bi_lvl.append([])
		for _y in range(map_size.y):
			map_as_bi_lvl[_x].append(Global_Block.e_BLOCKS.dirt)

	# Shuffle positions and connect them
	used_pos.shuffle()
	for index in range(used_pos.size() - 1):
		var point1 = gen_lvl_cor_to_id(used_pos[index])
		var point2 = gen_lvl_cor_to_id(used_pos[index + 1])
		for id in astar.get_id_path(point1, point2):
			var temp_pos = gen_lvl_id_to_cor(id)
			map_as_bi_lvl[temp_pos.x][temp_pos.y] = Global_Block.e_BLOCKS.air

	# Set each field around the buildings to air
	for _x in range(rand_pos.x - 1, rand_pos.x + 2):
		for _y in range(rand_pos.y - 1, rand_pos.y + 2):
			if is_cor_in_map(Vector2(_x, _y)):
				map_as_bi_lvl[_x][_y] = Global_Block.e_BLOCKS.air

	for _x in range(rand_pos_2.x - 1, rand_pos_2.x + 2):
		for _y in range(rand_pos_2.y - 1, rand_pos_2.y + 2):
			if is_cor_in_map(Vector2(_x, _y)):
				map_as_bi_lvl[_x][_y] = Global_Block.e_BLOCKS.air

	add_buildings_level(_level_cor, rand_pos, rand_pos_2)
	Player.set_new_wave_counter(levels.size())

func gen_empty_lvl(_level_cor):
	if map_as_bi.has(String(Global_AStar.level_cor_to_id(_level_cor))):
		return
	width = map_size.x
	height = map_size.y
	map_as_bi[String(Global_AStar.level_cor_to_id(_level_cor))] = []
	map_as_bi[String(Global_AStar.level_cor_to_id(_level_cor))].clear()
	var map_as_bi_lvl = map_as_bi[String(Global_AStar.level_cor_to_id(_level_cor))]

	for x in range(width):
		map_as_bi_lvl.append([])
		for _y in range(height):
			map_as_bi_lvl[x].append(Global_Block.e_BLOCKS.air)
	map_as_bi_lvl[15][15] = Global_Block.e_BLOCKS.dirt

func add_buildings_level(_level_cor, rand_pos, rand_pos_2):

	if !_level_cor == Vector2(0,0):
		var base1 = load("res://buildings/spawner/Enemy_Base_Small.tscn").instance()
		add_building(base1,rand_pos , _level_cor)
		base1.spawn_enemys(level_id_to_floor_number(_level_cor))
		var tf = load("res://buildings/player_buildings/Tower_Foundation.tscn")
		base1.add_spawn_on_kill(tf.instance())
	else:
		var tf = load("res://buildings/player_buildings/Tower_Foundation.tscn")
		add_building(tf.instance(),rand_pos , _level_cor)

	if !_level_cor == Vector2(0,0):
		var tf = load("res://buildings/player_buildings/Tower_Foundation.tscn")
		var base2 = load("res://buildings/spawner/Enemy_Base_Small.tscn").instance()
		add_building(base2,rand_pos_2 , _level_cor)
		base2.spawn_enemys(level_id_to_floor_number(_level_cor))
		base2.add_spawn_on_kill(tf.instance())
	else:
		var tf = load("res://buildings/player_buildings/Tower_Foundation.tscn")
		add_building(tf.instance(),rand_pos_2 , _level_cor)

func show_gen_buttons():
	var new_level
	new_level = levels.back() + Vector2(-1,0)
	if levels.find(new_level) == -1:
		var pos =  get_pos_on_map_mid(Vector2(0,int((map_size.y -1) / 2)), levels.back())
		pos += Vector2(-100,0)
		$Buttons/Gen_Level_Left.set_global_position(pos)
		$Buttons/Gen_Level_Left.disabled = false
		$Buttons/Gen_Level_Left.visible = true

	new_level = levels.back() + Vector2(0,1)
	if levels.find(new_level) == -1:
		var pos =  get_pos_on_map_mid(Vector2(int((map_size.x -1) / 2),int((map_size.y -1))), levels.back())
		pos += Vector2(0,50)
		$Buttons/Gen_Level_Down.set_global_position(pos)
		$Buttons/Gen_Level_Down.disabled = false
		$Buttons/Gen_Level_Down.visible = true

	new_level = levels.back() + Vector2(1,0)
	if levels.find(new_level) == -1:
		var pos =  get_pos_on_map_mid(Vector2(map_size.x -1,int((map_size.y -1) / 2)), levels.back())
		pos += Vector2(50,0)
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
	Global_AStar.add_level_to_astar(next_level)


func _on_Gen_Level_Down_pressed():
	var next_level = levels.back() + Vector2(0,1)
	gen_level(next_level)
	fill_blocks(next_level)
	Global_AStar.add_level_to_astar(next_level)
	pass

func _on_Gen_Level_Right_pressed():
	var next_level = levels.back() + Vector2(1,0)
	gen_level(next_level)
	fill_blocks(next_level)
	Global_AStar.add_level_to_astar(next_level)
