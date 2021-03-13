extends "res://effects/scripts/StatusEffect.gd"

signal spawn_bomb

export (float) var iniDamage
export (float) var explodeDamage
export (float) var explodeRadius

var body
var first = true

func _init():
	$Tags.add_tag($Tags.e_effect.cast_on_death)
	$Tags.add_tag($Tags.e_effect.health)
	$Tags.add_tag($Tags.e_effect.dont_stack)
	$Tags.add_tag($Tags.e_effect.animation)
	$Tags.add_tag($Tags.e_effect.debuff)
	$Tags.add_tag($Tags.e_effect.init)
	
	
func effekt(value, tag):
	if tag == $Tags.e_effect.init:
		parent = value
	if tag == $Tags.e_effect.health:
		$Tags.remove_tag($Tags.e_effect.health)
		return iniDamage
	if tag == $Tags.e_effect.cast_on_death:
		self.connect("spawn_bomb", self.get_tree().get_current_scene(), "_on_spawn_attack")
		var RuneAddShock = load("res://Rune/RuneAddShock.tscn").instance()
		var bomb = load ("res://Attack/StationaryBomb.tscn").instance()
		bomb.effect_damage(explodeDamage)
		bomb.set_explode_radius(explodeRadius)
		bomb.set_runes([RuneAddShock], null)
		bomb.effect_lifetime(0) 
		bomb.set_explode_animation_scale( Vector2(3,3))
		bomb.set_explode_animation_frames($Animation.frames)
		emit_signal('spawn_bomb', bomb, parent.global_position, parent.last_tower_hit)
	if tag == $Tags.e_effect.animation:
		$Animation.global_position = value.global_position
		$Animation.show()
		$Animation.play("shock")
		return
	return value
		
	
func find_targets(_body):
	var enemys = get_tree().get_nodes_in_group("enemys")
	var targets = []
	for e in enemys:
		if e != _body:
			var temp = _body.position.distance_to(e.position)
			if  _body.position.distance_to(e.position) <= explodeRadius:
				targets.append(e)
	return targets

	
func set_duration(_duration):
	duration = _duration
	$Tags.add_tag($Tags.e_effect.health)
	$Duration.wait_time = duration
	$Duration.start()

func get_description():
	var des = "Shocked enemys explode on deaths. Dealing " + str(explodeDamage) + " dmg and shocks enemys"
	return des
