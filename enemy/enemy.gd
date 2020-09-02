extends KinematicBody2D

signal health_changed
#signal dead

export (int) var speed = 200
export (int) var damage = 10
export (int) var gold_value = 20
export (int) var max_health = 200
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

var start_pos_as_cor = Vector2(0, 0)
var target_pos_as_cor = Vector2(0, 0)

var spawner = null

var spawned = false

func _ready():
	map = get_tree().get_root().get_node("map")
	
	# find_way(Vector2(7, 0))
func set_last_tower_hit(_last_tower_hit):
	last_tower_hit = _last_tower_hit

func spawn(_position, _start_cor, _start_level_cor):
	global_position = _position
	health = max_health
	start_pos_as_cor = _start_cor
	start_level_cor = _start_level_cor
	
	for x in $StatusEffects.get_Status_list($Tags.e_effect.init):
		x.effekt(self, $Tags.e_effect.init)
	spawned = true
	

func control(delta):
	calc_move_direction()
	var changed_speed = speed
	for x in $StatusEffects.get_Status_list($Tags.e_effect.speed):
		changed_speed = x.effekt(changed_speed, $Tags.e_effect.speed)
	for x in $StatusEffects.get_Status_list($Tags.e_effect.health):
		take_damage(x.effekt(health, $Tags.e_effect.health))
	for x in $StatusEffects.get_Status_list($Tags.e_effect.direction):
		move_direction = x.effekt(move_direction, $Tags.e_effect.direction)	
	
	if !$Animation.is_playing():
		$Animation.play('walk')
		$Sprite.visible = true
	else:
		$Sprite.visible = false
	if $Animation.is_playing() and speed != changed_speed:
		var farmes_count = $Animation.frames.get_frame_count('walk')
		$Animation.frames.set_animation_speed('walk', farmes_count*changed_speed/speed)
	velocity = move_direction * changed_speed * delta * -100	
	
	for x in $StatusEffects.get_Status_list($Tags.e_effect.animation):
		x.effekt(self, $Tags.e_effect.animation)
			
	if health <= 0:
		die()
		
func take_damage(_damage):
	if dead or _damage == null:
		return	
	for x in $StatusEffects.get_Status_list($Tags.e_effect.took_dmg):
		_damage = x.effekt(_damage, $Tags.e_effect.took_dmg)
	if _damage == 0:
		return
	health = health - _damage
	if health > max_health:
		health = max_health	
	if health < 0:
		health = 0
	
	emit_signal('health_changed',health)	
		
func die():
	for x in $StatusEffects.get_Status_list($Tags.e_effect.cast_on_death):
			x.effekt(self,$Tags.e_effect.cast_on_death)
	
	if player:
		player.add_money(gold_value)
	kill()
		
func kill():
	dead = true
	if spawner:
		spawner.remove_enemy(self)
	map.remove_enemy(self)
	queue_free()
	
func _physics_process(delta):
		if dead:
			return
		control(delta)
		var _rc 
		_rc = move_and_slide(velocity)
		
func get_velocity():
	return velocity
	
func add_Status(_status):
	$StatusEffects.add_Status(_status)
	if _status.has_icon():
		add_Status_Icon(_status)
	
	if spawned and _status.has_tag($Tags.e_effect.init):
		_status.effekt(self, $Tags.e_effect.init)
	

func add_Status_Icon(_status):
	var icon = _status.get_icon().duplicate()
	icon.visible = true
	$StatusLeiste.add_child(icon)
	
func remove_Status_Icon(_status):
	for icon in $StatusLeiste.get_children():
		var _status_icon = _status.get_icon()
		if icon.texture == _status_icon.texture:
			$StatusLeiste.remove_child(icon)
			return

func remove_Status(_status):
	$StatusEffects.remove_Status(_status)
	if _status.has_icon():
		remove_Status_Icon(_status)

func get_StatusEffects(_tag = null):
	return  $StatusEffects.get_Status_list(_tag)

func load_settings(_settings):
	if _settings.empty():
		return
	for k in _settings.keys():
		set(k ,_settings[k])

func calc_move_direction():
	if way_points.size() >= 1:
		move_direction = (position - way_points[0]).normalized()
		if position.distance_to(way_points[0]) < 10:
			way_points.erase(way_points[0])		
	else:
		move_direction = Vector2(0, 0)
		var heart = map.get_heart()
		find_way(heart.get_cor(), heart.get_level_cor())
	if move_direction.x > 0.1: #You know why 0.1
		if $Sprite.scale.x > 0: 
			$Sprite.scale.x *= -1
		if $Animation.scale.x > 0: 
			$Animation.scale.x *= -1
	else:
		if $Sprite.scale.x < 0: 
			$Sprite.scale.x *= -1
		if $Animation.scale.x < 0: 
			$Animation.scale.x *= -1

func find_way(_target, _level_cor):
	astar = Global_AStar.get_astar()
	var point1 = Global_AStar.get_id_of_point(Vector3(start_pos_as_cor.x, start_pos_as_cor.y, Global_AStar.level_cor_to_id(start_level_cor)))
	var point2 = Global_AStar.get_id_of_point(Vector3(_target.x, _target.y, Global_AStar.level_cor_to_id(_level_cor)))

	var path = astar.get_id_path(point1,point2)
	
	if start_level_cor != Vector2(0,0):
		pass
	
	for id in path:
		var point = astar.get_point_position(id)
		var level_cor = Global_AStar.id_to_level_cor(point.z)
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
