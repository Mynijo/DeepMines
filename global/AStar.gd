extends Node2D


var astar
var map_size

var map_as_bi = {}


func set_map_size(var _map_size):
	map_size = _map_size


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
					
func level_cor_to_id(_level_cor):
	return _level_cor.y * 1000000 + (_level_cor.x +1000)
	
func id_to_level_cor(_id):
	var x = (int(_id) % 1000000) 
	if x != 0:
		x -=  1000
	var y = stepify((_id +1000)/1000000, 1)
	return Vector2(x, y)
