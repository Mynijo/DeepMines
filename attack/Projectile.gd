extends Area2D

export (int) var speed
var speed_effected
export (float) var damage
var damage_effected
export (float) var lifetime
var lifetime_effected
export (float) var crit_chance
var crit_chance_effected
export (float) var direction
var direction_effected

export (int) var max_target = 1

var velocity = Vector2()
var runes = []



var tower

func start(_position, _direction, _tower):
	position = _position
	direction = _direction
	rotation = get_direction().angle()
	$Lifetime.wait_time = get_lifetime()
	velocity = get_direction() * get_speed()
	$Lifetime.start()
	tower = _tower
	init_runes()

func _process(delta):
	for r in runes:
		if r.has_tag($Tags.e_rune.process_animation):			
			r.effect(self, $Tags.e_rune.process_animation)
			
	position += velocity * delta
	
	for r in runes:
		if r.has_tag($Tags.e_rune.whlie_processing):			
			if !r.effect(delta, $Tags.e_rune.whlie_processing):
				return
	

func explode():
	for r in runes:
		var temp = r.get_tags()
		if r.has_tag($Tags.e_rune.explode):
			if !r.effect(self, $Tags.e_rune.explode):
				return
	queue_free()
	
func _on_Attack_body_entered(body):
	var target_counter = max_target
	if body.has_method('take_damage') and target_counter > 0:
		target_counter -= 1
		body.take_damage(calcDmg(body))
		for r in runes:
			if r.has_tag($Tags.e_rune.enemy_was_dmg):
				r.effect(body,$Tags.e_rune.enemy_was_dmg)
	
	var result 
	if "last_tower_hit" in body:
		body.last_tower_hit = tower
	for r in runes:
		if r.has_tag($Tags.e_rune.enemy_was_hit):			
			if !r.effect(body, $Tags.e_rune.enemy_was_hit): # continue?
				return
	explode()
	
func _on_Lifetime_timeout():
	explode()

func calcDmg(_body):
	var dmg = get_damage()
	if rand_range(0, 100) < get_crit_chance():
		dmg *= 2
		for r in runes:
			if r.has_tag($Tags.e_rune.enemy_was_crit):
				r.effect(_body, $Tags.e_rune.enemy_was_crit)
	return dmg		


func set_runes(_runes, _tower):
	var rune
	for r in _runes:
		rune = r.duplicate(DUPLICATE_USE_INSTANCING)
		add_child(rune)
		if rune.has_tag($Tags.e_rune.init_tower):
			rune.effect(_tower, $Tags.e_rune.init_tower)
		runes.append(rune)

func init_runes():
	for r in runes:		
		if r.has_tag($Tags.e_rune.init_attack):
			r.effect(self, $Tags.e_rune.init_attack)
		if r.has_tag($Tags.e_rune.effect_attack):
			r.effect(self, $Tags.e_rune.effect_attack)

func get_lifetime():
	if lifetime_effected:
		return lifetime_effected
	return lifetime
func effect_lifetime(_lifetime):
	lifetime_effected = _lifetime

func get_speed():
	if speed_effected:
	 return speed_effected
	return speed
func effect_speed(_speed):
	speed_effected = _speed

func get_direction():
	if direction_effected:
	 return direction_effected
	return direction
func effect_direction(_direction):
	rotation = _direction.angle()
	direction_effected = _direction
	velocity = _direction * get_speed()


func get_damage():
	if damage_effected:
		return damage_effected
	return damage
func effect_damage(_damage):
	damage_effected = _damage

func get_crit_chance():
	if crit_chance_effected:
		return crit_chance_effected
	return crit_chance
func effect_crit_chance(_crit_chance):
	crit_chance_effected = _crit_chance

func is_Attack():
	return true

