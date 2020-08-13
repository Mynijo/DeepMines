extends KinematicBody2D

export (float) var gun_cooldown
var gun_cooldown_effected
export (int) var detect_radius
var detect_radius_effected

export (int) var cost = 50
export (float) var turret_speed = 1.0

var runes_attached = []
var runes_active = []

var Attack

signal shoot

var target = []

var experience = 0

var can_shoot = true

onready var ray := $Node/RayCast2D


enum e_rule{
	closest_first
}


func _ready():	
	$GunCooldown.wait_time = get_gun_cooldown()
	$DetectRadius/CollisionShape2D.shape = CircleShape2D.new()
	$DetectRadius/CollisionShape2D.shape.radius = get_detect_radius()
	$Node/RayCast2D.cast_to.y = get_detect_radius()
	#runes_attached.append(load("res://rune/RuneBurst.tscn").instance())
	#runes_attached.append(load("res://rune/RuneScatterShot.tscn").instance())
	#runes_attached.append(load("res://rune/RuneFollowing.tscn").instance())
	#runes_attached.append(load("res://rune/RuneAddCharme.tscn").instance())
	#runes_attached.append(load("res://rune/RuneAddIgnite.tscn").instance())
	runes_attached.append(load("res://rune/RuneAddShock.tscn").instance())
	runes_attached.append(load("res://rune/RuneAddSlow.tscn").instance())
	#runes_attached.append(load("res://rune/RuneBoomerang.tscn").instance())
	#runes_attached.append(load("res://rune/RuneChain.tscn").instance())
	#runes_attached.append(load("res://rune/RuneIncreasedAps.tscn").instance())
	#runes_attached.append(load("res://rune/RunePierce.tscn").instance())
	#runes_attached.append(load("res://rune/RuneIncreaseTurretDetectRadius.tscn").instance())
	#runes_attached.append(load("res://rune/RuneWhirl.tscn").instance())
	apply_runes(runes_attached)
		
func _process(delta):	
	if target.size() != 0:
		order_by(e_rule.closest_first)
		var distance = (target.front().global_position - global_position).length()
		var attack = Attack.instance()
		var _time = (distance / (attack.get_speed()))
		attack.free()
		var predicted_position = target.front().global_position + (target[0].get_velocity() * _time)
		var target_dir = (predicted_position - global_position).normalized()
		
		var current_dir = Vector2(1, 0).rotated($Body.global_rotation)
		$Body.global_rotation = current_dir.linear_interpolate(target_dir, turret_speed * delta).angle()
		
		if target_dir.dot(current_dir) > 0.9999:
			$Node.look_at(target.front().global_position)
			ray.force_raycast_update()
			if ray.is_colliding():
				if ray.get_collider().is_in_group("enemys"):
					if can_shoot:
						shoot()
				else:
					pass
	else:
		var current_dir = Vector2(1, 0).rotated($Body.global_rotation)
		$Body.global_rotation = current_dir.linear_interpolate(Vector2(1,0), turret_speed * delta).angle()
		
func spawn(_position):
	position = _position
	self.connect("shoot", self.get_tree().get_current_scene(), "_on_Tower_shoot")


func order_by(order_by):
	if target.size() <= 0:
		return
	var temp = target.front()
	if order_by == e_rule.closest_first:
		var closest = null
		for t in target:
			$Node.look_at(t.global_position)
			ray.force_raycast_update()
			if ray.is_colliding():
				if ray.get_collider().is_in_group("enemys"):
					if closest == null or global_position.distance_to(t.global_position) < global_position.distance_to(closest.global_position):
						closest = t
		if closest != target.front() and closest != null:
			target.erase(closest)
			target.push_front(closest)


func _on_DetectRadius_body_entered(body):
	if body.has_method('is_Enemy'):
		target.append(body)
	else:
		pass
	

func _on_DetectRadius_body_exited(body):
	target.erase(body)
		
func shoot():	
	$GunCooldown.start()
	can_shoot = false
	var b = Attack.instance()		
	if runes_active:		
		b.set_runes(runes_active, self)
	emit_signal('shoot', b, global_position, Vector2(1, 0).rotated($Body.global_rotation), self)
	
	for r in runes_active:
		if r.has_tag($Tags.e_rune.shoot):
			r.effect(self,$Tags.e_rune.shoot)

func _on_GunCooldown_timeout():
	can_shoot = true
	
func get_gun_cooldown():
	if gun_cooldown_effected:
		return gun_cooldown_effected
	return gun_cooldown
	
func effect_gun_cooldown(_gun_cooldown):
	gun_cooldown_effected = _gun_cooldown
	$GunCooldown.wait_time = gun_cooldown_effected
	$GunCooldown.start()
	
func get_detect_radius():
	if detect_radius_effected:
		return detect_radius_effected
	return detect_radius
	
func effect_detect_radius(_detect_radius):
	detect_radius_effected = _detect_radius
	$DetectRadius/CollisionShape2D.shape.radius = detect_radius_effected
	$Node/RayCast2D.cast_to.y = detect_radius_effected
	
func runes_changed():
	reset_tower()
	apply_runes(runes_attached)
	
func apply_runes(_runes):
	for r in _runes:
		add_child(r)
		if r.has_tag($Tags.e_rune.init_tower):
			r.effect(self, $Tags.e_rune.init_tower)
		if r.has_tag($Tags.e_rune.effect_tower):
			r.effect(self, $Tags.e_rune.effect_tower)
		runes_active.append(r)

func reset_tower():
	for r in runes_active:
		r.queue_free()
		remove_child(r)
	runes_active.clear()
	effect_gun_cooldown(gun_cooldown)
	effect_detect_radius(detect_radius)

func is_Tower():
	return true

func add_exp(_exp):
	experience += _exp


func _on_DetectRadius_mouse_entered():
	pass # Replace with function body.
