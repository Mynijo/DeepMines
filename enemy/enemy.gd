extends KinematicBody2D

signal health_changed
signal dead

export (int) var speed
export (int) var experience
export (int) var damage
export (int) var gold_value = 5
export (int) var max_health
var health

var last_tower_hit = null
var tags
var dead = false

var astar



var way_points = []
var move_direction = Vector2(0, 0)
var velocity = Vector2()

export (Vector2) var start_pos_as_cor = Vector2(0, 0)
export (Vector2) var target_pos_as_cor = Vector2(0, 0)

func _ready():
	spawn( get_parent().get_pos_on_map_mid(start_pos_as_cor))
	find_way(target_pos_as_cor)
	# find_way(Vector2(7, 0))
		
func spawn(_position):
	global_position = _position
	health = max_health

func control(delta):
	calc_move_direction()
	var changed_speed = speed
	for x in $StatusEffects.get_Status_list($Tags.e_effect.speed):
		changed_speed = x.effekt(changed_speed, $Tags.e_effect.speed)
	for x in $StatusEffects.get_Status_list($Tags.e_effect.health):
		take_damage(x.effekt(health, $Tags.e_effect.health))
	for x in $StatusEffects.get_Status_list($Tags.e_effect.direction):
		move_direction = x.effekt(move_direction, $Tags.e_effect.direction)	
	
	if $Animation.has_animation('walk'):
		if 	!$Animation.is_playing():
			$Animation.play('walk')		
		if speed != changed_speed:
			$Animation.playback_speed = changed_speed/speed		
	velocity = move_direction * changed_speed * delta * -100	
	
	for x in $StatusEffects.get_Status_list($Tags.e_effect.animation):
		x.effekt(self, $Tags.e_effect.animation)
			
	if health <= 0:
		die()
		
func take_damage(_damage):
	if dead or _damage == null:
		return	
	health = health - _damage
	emit_signal('health_changed',health)	
		
func die():
	for x in $StatusEffects.get_Status_list($Tags.e_effect.cast_on_death):
			x.effekt(self,$Tags.e_effect.cast_on_death)
	
	if get_parent().get_player():
		get_parent().get_player().add_money(gold_value)
	if last_tower_hit:
		last_tower_hit.add_exp(experience)
	kill()
		
func kill():
	dead = true
	queue_free()
	
func _physics_process(delta):
		if dead:
			return
		control(delta)
		move_and_slide(velocity)
		
func get_velocity():
	return velocity
	
func add_Status(_status):	
	$StatusEffects.add_Status(_status)
	
	if _status.has_tag($Tags.e_effect.init):
		_status.effekt(self, $Tags.e_effect.init)

func remove_Status(_status):
	$StatusEffects.remove_Status(_status)

func get_StatusEffects(_tag = null):
	return  $StatusEffects.get_Status_list(_tag)

func load_settings(_settings):
	if _settings[0][0]:
		for s in _settings:
			set(s[0],s[1])

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

func find_way(_target):
	ini_astar()
	var path = astar.get_id_path(cor_to_id(start_pos_as_cor), cor_to_id(_target))	
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
	

func is_Enemy():
	return true
