extends KinematicBody2D

signal take_damage
signal health_changed
signal dead

export (int) var speed
export (int) var experience
export (int) var damage
export (int) var gold_value = 5
export (int) var max_health
var health

var way_points = []
var move_direction = Vector2(0, 0)

var dead = false
var offset_pos = Vector2(32, 32)

var velocity = Vector2()

var astar

func _ready():
	spawn( get_parent().get_pos_on_map_mid(Vector2(0, 0)))
	find_way(Vector2(2, 2))

func spawn(_position):
	global_position = _position
	health = max_health
		
func _physics_process(delta):
		if dead:
			return
		control(delta)		
		move_and_slide(velocity)	


func control(delta):	
	var changed_speed = speed
	calc_move_direction()	
	velocity = move_direction * changed_speed * delta * -100
	if $Animation.has_animation('walk'):
		if 	!$Animation.is_playing():
			$Animation.play('walk')		
		if speed != changed_speed:
			$Animation.playback_speed = changed_speed/speed

func calc_move_direction():
	if way_points.size() >= 1:
		move_direction = (position - way_points[0]).normalized()
		if position.distance_to(way_points[0]) < 1:
			way_points.erase(way_points[0])		
	else:
		move_direction = Vector2(0, 0)
	if move_direction.x > 0.1: #You know why 0.1
		$Sprite.scale.x = -1
	else:
		$Sprite.scale.x = 1
	
	
func take_damage(damage):
	if dead or damage == null:
		return	
	health = health - damage
	emit_signal('health_changed',health)	
		
func die():
	if get_parent().player:
		get_parent().player.add_money(gold_value)
	dead()
		
func dead():
	dead = true
	queue_free()
		
func get_velocity():
	return velocity
	
func find_way(_target):
	ini_astar()
	var path = astar.get_id_path(cor_to_id(Vector2(0,0)), cor_to_id(_target))	
	for id in path:
		way_points.append(get_parent().get_pos_on_map_mid(id_to_cor(id)))
	
	
	
	
	
	
func ini_astar():
	var map_size = get_parent().get_map_size()
	var map_as_bi = get_parent().get_map_as_bi()
	astar = AStar.new()
	if astar == null:
		astar = AStar.new()
	else:
		astar.clear()
		
	for x in range(map_size.x):
		for y in range(map_size.y):
			astar.add_point(cor_to_id(Vector2(x,y)), Vector3(x, y, 0))
			
	for x in range(map_size.x):
		for y in range(map_size.y):
			if map_as_bi[x][y]:
				if x -1 >= 0:
					if map_as_bi[x -1][y]:
						astar.connect_points(cor_to_id(Vector2(x,y)), cor_to_id(Vector2(x -1,y)), true)
				if y -1 >= 0:
					if map_as_bi[x][y -1]:
						astar.connect_points(cor_to_id(Vector2(x,y)), cor_to_id(Vector2(x ,y -1)), true)
				
			
			
	

	
func cor_to_id(cor):
	return cor.x * 10000 + cor.y
	
func id_to_cor(id):
	return Vector2(stepify(id/10000, 1),id % 10000)
	
