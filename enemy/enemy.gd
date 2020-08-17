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
var map
var player

var start_level_cor
var way_points = []
var move_direction = Vector2(0, 0)
var velocity = Vector2()

export (Vector2) var start_pos_as_cor = Vector2(0, 0)
export (Vector2) var target_pos_as_cor = Vector2(0, 0)

var spawner = null

func _ready():
	map = get_tree().get_root().get_node("map")
	player = map.get_player()
	
	
	# find_way(Vector2(7, 0))
		
func spawn(_position, _start_cor, _start_level_cor):
	global_position = _position
	health = max_health
	start_pos_as_cor = _start_cor
	start_level_cor = _start_level_cor
	
	

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
	
	if player:
		player.add_money(gold_value)
	if last_tower_hit:
		last_tower_hit.add_exp(experience)
	kill()
		
func kill():
	dead = true
	spawner.remove_enemy(self)
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
		var heart = map.get_heart()
		find_way(heart.get_cor(), heart.get_level_cor())
	if move_direction.x > 0.1: #You know why 0.1
		$Sprite.scale.x = -1
	else:
		$Sprite.scale.x = 1

func find_way(_target, _level_cor):
	astar = map.get_astar()
	var point1 = astar.get_closest_point(Vector3(start_pos_as_cor.x, start_pos_as_cor.y, map.level_cor_to_id(start_level_cor)))
	var point2 = astar.get_closest_point(Vector3(_target.x, _target.y, map.level_cor_to_id(_level_cor)))

	var path = astar.get_id_path(point1,point2)
	
	if start_level_cor != Vector2(0,0):
		pass
	
	for id in path:
		var point = astar.get_point_position(id)
		var level_cor = map.id_to_level_cor(point.z)
		var cor = Vector2(point.x, point.y)
		if level_cor != Vector2(0,0):
			pass
		way_points.append(map.get_pos_on_map_mid(cor, level_cor))



	
func hit_building_get_dmg():
	kill()
	return damage

func is_Enemy():
	return true
	
func add_spawner(_spawner):
	spawner = _spawner
