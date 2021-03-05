extends Node2D


var astar
var map_size
var heath_cor

var map_level_block = {}


func set_map_size(var _map_size):
	map_size = _map_size


func set_heart(_cor, _level_cor):
	heath_cor = Vector3(_cor.x, _cor.y, level_cor_to_id(_level_cor))

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
			var temp_id = astar.get_point_count()
			astar.add_point(temp_id, Vector3(x, y, level_cor_to_id(_level_cor)))
		
	var map_level = map_level_block[String(level_cor_to_id(_level_cor))]
	for x in range(map_size.x):
		for y in range(map_size.y):
			if map_level[x][y].Walkable:
				if x -1 >= 0:
					if map_level[x -1][y].Walkable:
						var point1 = get_id_of_point(Vector3(   x, y, level_cor_to_id(_level_cor)))
						var point2 = get_id_of_point(Vector3(x -1, y, level_cor_to_id(_level_cor)))
						astar.connect_points(point1, point2, true)
				if y -1 >= 0:
					if map_level[x][y -1].Walkable:
						var point1 = get_id_of_point(Vector3( x, y  , level_cor_to_id(_level_cor)))
						var point2 = get_id_of_point(Vector3( x, y -1, level_cor_to_id(_level_cor)))
						astar.connect_points(point1, point2, true)
						
	if map_level_block.has(String(level_cor_to_id(_level_cor + Vector2(1,0)))):
		var neighbour_level = map_level_block[String(level_cor_to_id(_level_cor + Vector2(1,0)))]
		for y in range(map_size.y):
			if map_level[map_size.x -1][y].Walkable && neighbour_level[0][y]:
					var point1 = get_id_of_point(Vector3(map_size.x -1, y, level_cor_to_id(_level_cor)))
					var point2 = get_id_of_point(Vector3(            0, y, level_cor_to_id(_level_cor+ Vector2(1,0))))
					astar.connect_points(point1, point2, true)
					
	if map_level_block.has(String(level_cor_to_id(_level_cor + Vector2(-1,0)))):
		var neighbour_level = map_level_block[String(level_cor_to_id(_level_cor + Vector2(-1,0)))]
		for y in range(map_size.y):
			if map_level[0][y].Walkable && neighbour_level[map_size.x -1][y]:
					var point1 = get_id_of_point(Vector3(             0, y, level_cor_to_id(_level_cor)))
					var point2 = get_id_of_point(Vector3( map_size.x -1, y, level_cor_to_id(_level_cor+ Vector2(-1,0))))
					astar.connect_points(point1, point2, true)

	if map_level_block.has(String(level_cor_to_id(_level_cor + Vector2(0,1)))):
		var neighbour_level = map_level_block[String(level_cor_to_id(_level_cor + Vector2(0,1)))]
		for x in range(map_size.x):
			if map_level[x][map_size.y -1].Walkable && neighbour_level[x][0]:
					var point1 = get_id_of_point(Vector3( x, map_size.y -1, level_cor_to_id(_level_cor)))
					var point2 = get_id_of_point(Vector3( x,             0, level_cor_to_id(_level_cor+ Vector2(0,1))))
					astar.connect_points(point1, point2, true)

	if map_level_block.has(String(level_cor_to_id(_level_cor + Vector2(0,-1)))):
		var neighbour_level = map_level_block[String(level_cor_to_id(_level_cor + Vector2(0,-1)))]
		for x in range(map_size.x):
			if map_level[x][0].Walkable && neighbour_level[x][map_size.y -1]:
					var point1 = get_id_of_point(Vector3( x,             0, level_cor_to_id(_level_cor)))
					var point2 = get_id_of_point(Vector3( x, map_size.y -1, level_cor_to_id(_level_cor+ Vector2(0,-1))))
					astar.connect_points(point1, point2, true)
					
func level_cor_to_id(_level_cor):
	return _level_cor.y * 1000000 + (_level_cor.x +1000)
	
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
	neighbour = get_neighbour(node_cor + Vector3( 1,0,0))
	if neighbour != -1:
		neighbours.append(neighbour)
	neighbour = get_neighbour(node_cor + Vector3(-1,0,0))
	if neighbour != -1:
		neighbours.append(neighbour)
	neighbour = get_neighbour(node_cor + Vector3(0, 1,0))
	if neighbour != -1:
		neighbours.append(neighbour)
	neighbour = get_neighbour(node_cor + Vector3(0,-1,0))
	if neighbour != -1:
		neighbours.append(neighbour)
	return neighbours


func get_neighbour(_pos):
	var temp_pos = _pos
	var temp_level_cor = id_to_level_cor(_pos.z)
	if temp_pos.x < 0:
		temp_pos.x = map_size.x - 1
		temp_level_cor += Vector2(-1,0)
	if temp_pos.x >= map_size.x:
		temp_pos.x = 0
		temp_level_cor += Vector2( 1,0)
	if temp_pos.y < 0:
		temp_pos.y = map_size.y - 1
		temp_level_cor += Vector2( 0,-1)
	if temp_pos.y >= map_size.y:
		temp_pos.y = 0
		temp_level_cor += Vector2( 0, 1)
	temp_pos.z = level_cor_to_id(temp_level_cor)
	return get_id_of_point(temp_pos)
		
	
func is_replacement_valid(_block_old, _block_new):
	if _block_new.Walkable:
		return true
	var rc = true
	var node_id = get_id_of_point(Vector3(_block_old.Cor.x, _block_old.Cor.y, level_cor_to_id(_block_old.Level_cor)))
	var neighbours = get_neighbours(node_id)
	if neighbours.size() <= 3:
		return false
	for n in neighbours:
		astar.disconnect_points(node_id, n)
	var n_pos
	var path
	for n in neighbours:
		n_pos = astar.get_point_position(n)
		if map_level_block[String(n_pos.z)][n_pos.x][n_pos.y].Walkable:
			path = astar.get_id_path(get_id_of_point(heath_cor), n)
			if path.empty():
				rc = false
				break
	recalc_id(node_id)
	return rc
	
func recalc(_cor, _level_cor):
	var node_id = get_id_of_point(Vector3(_cor.x, _cor.y, level_cor_to_id(_level_cor)))
	recalc_id(node_id)
		
func recalc_id(_node_id):
	var neighbours = get_neighbours(_node_id)
	for n in neighbours:
		astar.disconnect_points(_node_id, n)
	var _node_pos  = astar.get_point_position(_node_id)
	if !map_level_block[String(_node_pos.z)][_node_pos.x][_node_pos.y].Walkable:
	 return
	
	var n_pos
	for n in neighbours:
		n_pos = astar.get_point_position(n)
		if map_level_block[String(n_pos.z)][n_pos.x][n_pos.y].Walkable:
			astar.connect_points(_node_id, n)
