extends "res://buildings/Building.gd"

export (float) var gun_cooldown
var gun_cooldown_effected
export (int) var detect_radius
var detect_radius_effected

export (int) var cost = 50
export (float) var turret_speed = 1.0

var runes_attached = []
var runes_active = []

export (PackedScene) var Attack

signal shoot

var target = []

var experience = 0

signal Runes_Changed
var can_shoot = true

var recalc_target = true

onready var ray := $RayCastAnchor/RayCast2D


enum e_rule{
	closest_first
}

func _ready():
	map = get_tree().get_root().get_node("map")
	connect_signals()

func build_me():	
	$GunCooldown.wait_time = get_gun_cooldown()
	$DetectRadius/CollisionShape2D.shape = CircleShape2D.new()
	$DetectRadius/CollisionShape2D.shape.radius = get_detect_radius()
	$RayCastAnchor/RayCast2D.cast_to.y = get_detect_radius()
	#runes_attached.append(load("res://rune/RuneBurst.tscn").instance())
	#runes_attached.append(load("res://rune/RuneScatterShot.tscn").instance())
	#runes_attached.append(load("res://rune/RuneFollowing.tscn").instance())
	#runes_attached.append(load("res://rune/RuneAddCharme.tscn").instance())
	#runes_attached.append(load("res://rune/RuneAddIgnite.tscn").instance())
	#runes_attached.append(load("res://rune/RuneAddShock.tscn").instance())	
	#runes_attached.append(load("res://rune/RuneBoomerang.tscn").instance())
	#runes_attached.append(load("res://rune/RuneChain.tscn").instance())
	#runes_attached.append(load("res://rune/RuneIncreasedAps.tscn").instance())
	#runes_attached.append(load("res://rune/RunePierce.tscn").instance())
	#runes_attached.append(load("res://rune/RuneIncreaseTurretDetectRadius.tscn").instance())
	#runes_attached.append(load("res://rune/RuneWhirl.tscn").instance())
	#runes_attached.append(load("res://rune/RuneFollowing.tscn").instance())
	#runes_attached.append(load("res://rune/RuneTornadoShot.tscn").instance())
	#runes_attached.append(load("res://rune/RuneAddStickyBomb.tscn").instance())
	runes_attached.append(load("res://rune/RuneSplitShot.tscn").instance())
	emit_signal('Runes_Changed')	
	deactivate_preview()

func get_icon():
	return $Body.texture
	
func connect_signals():
	var _rc
	_rc = self.connect("shoot", self.get_tree().get_current_scene(), "_on_Tower_shoot")
	_rc = self.get_tree().get_current_scene().connect("Runes_Changed", self , "runes_changed")
	_rc = self.connect("Runes_Changed", self, "runes_changed")

func add_rune(_rune):
	runes_attached.append(_rune)
	emit_signal('Runes_Changed')

func remove_rune(_rune):
	runes_attached.remove(_rune)
	emit_signal('Runes_Changed')

		
func _process(delta):	
	if target.size() != 0:
		if recalc_target:
			order_by(e_rule.closest_first)
			$TargetSelectionColldown.start()
			recalc_target = false
		var distance = (target.front().global_position - global_position).length()
		var attack = Attack.instance()
		var _time = (distance / (attack.get_speed()))
		attack.free()
		var predicted_position = target.front().global_position + (target[0].get_velocity() * _time)
		var target_dir = (predicted_position - global_position).normalized()
		
		var current_dir = Vector2(1, 0).rotated($Body.global_rotation)
		$Body.global_rotation = current_dir.linear_interpolate(target_dir, turret_speed * delta).angle()
		
		if target_dir.dot(current_dir) > 0.999:
			$RayCastAnchor.look_at(target.front().global_position)
			ray.force_raycast_update()
			if ray.is_colliding():
				if ray.get_collider().is_in_group("enemys"):
					if can_shoot:
						shoot()
				else:
					pass
	else:
		#var current_dir = Vector2(1, 0).rotated($Body.global_rotation)
		#$Body.global_rotation = current_dir.linear_interpolate(Vector2(1,0), turret_speed * delta).angle()
		pass
		
func spawn(_position):
	position = _position
	build_me()


func order_by(order_by):
	if target.size() <= 0:
		return
	if order_by == e_rule.closest_first:
		var closest = null
		for t in target:
			$RayCastAnchor.look_at(t.global_position)
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
	if gun_cooldown_effected > 0:
		$GunCooldown.wait_time = gun_cooldown_effected
		$GunCooldown.start()
	
func get_detect_radius():
	if detect_radius_effected:
		return detect_radius_effected
	return detect_radius
	
func effect_detect_radius(_detect_radius):
	detect_radius_effected = _detect_radius
	if detect_radius_effected > 0:
		$DetectRadius/CollisionShape2D.shape.radius = detect_radius_effected
		$RayCastAnchor/RayCast2D.cast_to.y = detect_radius_effected
	
func runes_changed():
	reset_tower()
	var temp_runes = []
	var runes = map.get_Tower_Runes(0)
	for r in runes:
		temp_runes.append(r.duplicate())
	for r in runes_attached:
		temp_runes.append(r.duplicate())	
	apply_runes(temp_runes)
	
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
	
func _on_TargetSelectionColldown_timeout():
	recalc_target = true
