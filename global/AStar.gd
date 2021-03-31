extends Node2D


var astar
var map_size

var map_TileMap
var map

func get_id_path(id1, id2):
	return astar.get_id_path(id1, id2)

func set_map_size(var _map_size):
	map_size = _map_size
	
func set_map(var _map):
	map = _map

func get_astar():
	return astar

func ini_astar():
	astar = AStar.new()
	map_TileMap = map.get_TileMap()
	if astar == null:
		astar = AStar.new()
	else:
		astar.clear()
		

func get_heart_cor3d():
	var heart_cor = map.get_heart_cor()
	return Vector3(heart_cor.x, heart_cor.y, 0) 

func add_level_to_astar(_level_cor):
	var level_cor_start = map.get_global_cor(Vector2(0, 0), _level_cor)
	var level_cor_end   = map.get_global_cor(map_size, _level_cor) - Vector2(1, 1)
	
	for x in range(level_cor_start.x , level_cor_end.x +1):
		for y in range(level_cor_start.y , level_cor_end.y +1):
			#var temp_id = astar.get_point_count()
			var temp_id = map.gen_lvl_cor_to_id(Vector2(x,y))
			astar.add_point(temp_id, Vector3(x, y, 0))
			
	for x in range(level_cor_start.x , level_cor_end.x +1):
		for y in range(level_cor_start.y , level_cor_end.y +1):
			if map.block_typs[map_TileMap.get_cell(x,y)].walkable:
				if map.block_typs[map_TileMap.get_cell(x -1,y)].walkable:
					connect_via_cor(Vector2(x, y), Vector2(x-1, y))
				if map.block_typs[map_TileMap.get_cell(x,y -1)].walkable:
					connect_via_cor(Vector2(x, y), Vector2(x, y -1))
				if map.block_typs[map_TileMap.get_cell(x +1,y)].walkable:
					connect_via_cor(Vector2(x, y), Vector2(x+1, y))
	
	
	
func connect_via_cor(cor1, cor2):
	var point1 = get_id_of_point(Vector3( cor1.x, cor1.y, 0))
	var point2 = get_id_of_point(Vector3( cor2.x, cor2.y, 0))
	astar.connect_points(point1, point2, true)
	
func id_to_level_cor(_id):
	var x = (int(_id) % 1000000) 
	if x != 0:
		x -=  1000
	var y = stepify((_id +1000)/1000000, 1)
	return Vector2(x, y)
	
func cor_to_id(_level_cor):
	return _level_cor.y * 10000 + _level_cor.x
	
func id_to_cor(_id):
	var x = (int(_id) % 10000) 
	var y = stepify(_id /10000, 1)
	return Vector2(x, y)
	
	
func get_id_of_point(var _vector):
	var id = astar.get_closest_point(_vector)
	var temp_pos = astar.get_point_position(id)
	if temp_pos == _vector:
		return id
	else:
		return -1
	
func get_neighbours(_node_id):
	var neighbours = []
	var node_cor = astar.get_point_position(_node_id)
	
	var neighbour
	neighbour = get_id_of_point(node_cor + Vector3( 1,0,0))
	if neighbour != -1:
		neighbours.append(neighbour)
	neighbour = get_id_of_point(node_cor + Vector3(-1,0,0))
	if neighbour != -1:
		neighbours.append(neighbour)
	neighbour = get_id_of_point(node_cor + Vector3(0, 1,0))
	if neighbour != -1:
		neighbours.append(neighbour)
	neighbour = get_id_of_point(node_cor + Vector3(0,-1,0))
	if neighbour != -1:
		neighbours.append(neighbour)
	return neighbours


	
func is_disable_valid(cor):
	
	if(map.is_current_entry(cor)):
		return false
	
	var rc = true
	var node_id = get_id_of_point(Vector3( cor.x, cor.y, 0))
	var neighbours = get_neighbours(node_id)
	
	var old_tile = map_TileMap.get_cellv(cor)
	map_TileMap.set_cellv(cor, 0)
	recalc_id(node_id)
	
	var n_pos
	var path
	for n in neighbours:
		n_pos = astar.get_point_position(n)
		if map.block_typs[map_TileMap.get_cell(n_pos.x, n_pos.y)].walkable:
			path = astar.get_id_path(get_id_of_point(get_heart_cor3d()), n)
			if path.empty():
				rc = false
				break
				
	map_TileMap.set_cellv(cor, old_tile)
	recalc_id(node_id)
	return rc

func recalc(_cor):
	var node_id = get_id_of_point(Vector3(_cor.x, _cor.y, 0))
	recalc_id(node_id)
		
func recalc_id(_node_id):
	var neighbours = get_neighbours(_node_id)
	for n in neighbours:
		astar.disconnect_points(_node_id, n)
	var _node_pos  = astar.get_point_position(_node_id)
	if not map.block_typs[map_TileMap.get_cell(_node_pos.x, _node_pos.y)].walkable:
	 return
	
	var n_pos
	for n in neighbours:
		n_pos = astar.get_point_position(n)
		if map.block_typs[map_TileMap.get_cell(n_pos.x, n_pos.y)].walkable:
			astar.connect_points(_node_id, n)
