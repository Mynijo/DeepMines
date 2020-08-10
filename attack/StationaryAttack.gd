extends Area2D

export (int) var speed
var speed_effected
export (float) var damage
var damage_effected
export (float) var lifetime
var lifetime_effected
export (float) var crit_chance
var crit_chance_effected


var velocity = Vector2()
var runes = []

var tower

func spwan(_position, _tower):
	position = _position
	if !get_lifetime():
		lifetime_effected = 0.1
	$Lifetime.wait_time = get_lifetime()
	$Lifetime.start()
	tower = _tower

func _process(delta):
	for r in runes:
		if r.has_tag($Tags.e_rune.process_animation):			
			r.effect(self, $Tags.e_rune.process_animation)
			
	position += velocity * delta
	
	for r in runes:
		if r.has_tag($Tags.e_rune.whlie_processing):			
			if !r.effect(self, $Tags.e_rune.whlie_processing):
				return
	

func explode():
	for r in runes:
		var temp = r.get_tags()
		if r.has_tag($Tags.e_rune.explode):
			if !r.effect(self, $Tags.e_rune.explode):
				return
	queue_free()
	
func _on_Attack_body_entered(body):
	if body.has_method('take_damage'):
		body.take_damage(calcDmg(body))
		for r in runes:
			if r.has_tag($Tags.e_rune.enemy_was_dmg):
				r.effect(body,$Tags.e_rune.enemy_was_dmg)
	
	var result 
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
	return dmg		


func set_runes(_runes, _tower):
	var rune
	for r in _runes:
		rune = r.duplicate(DUPLICATE_USE_INSTANCING)
		add_child(rune)
		if rune.has_tag($Tags.e_rune.init_tower):
			rune.effect(_tower, $Tags.e_rune.init_tower)
		runes.append(rune)
	init_runes()

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

func get_damage():
	if damage_effected:
		return damage_effected
	return damage
func effect_damage(_damage):
	damage_effected = _damage


func is_Attack():
	return true

