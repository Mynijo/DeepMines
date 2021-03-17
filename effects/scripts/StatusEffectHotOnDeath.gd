extends "res://effects/scripts/StatusEffect.gd"

signal spawn_bomb

export (float) var iniDamage
export (float) var explodeDamage = 0
export (float) var explodeRadius

export (int) var heal_value = 10
export (int) var heal_duration = 10
export (float) var heal_tick_rate = 0.5
var body
var first = true

func _init():
	$Tags.add_tag($Tags.e_effect.cast_on_death)
	$Tags.add_tag($Tags.e_effect.buff)
	$Tags.add_tag($Tags.e_effect.init)
	$Tags.add_tag($Tags.e_effect.has_icon)
	
	
func effekt(value, tag):
	if tag == $Tags.e_effect.init:
		parent = value
	if tag == $Tags.e_effect.cast_on_death:
		self.connect("spawn_bomb", self.get_tree().get_current_scene(), "_on_spawn_attack")
		var RuneAddHot = load("res://rune/RuneAddHot.tscn").instance()
		
		RuneAddHot.heal_value = heal_value
		RuneAddHot.tick_rate = heal_tick_rate
		RuneAddHot.duration = heal_duration
		
		var bomb = load ("res://Attack/StationaryBomb.tscn").instance()
		bomb.effect_damage(explodeDamage)
		bomb.set_explode_radius(explodeRadius)
		bomb.set_runes([RuneAddHot], null)
		bomb.effect_lifetime(0) 
		bomb.set_explode_animation_scale( Vector2(2,2))
		bomb.set_explode_animation_frames($Animation.frames)
		emit_signal('spawn_bomb', bomb, parent.global_position, parent.last_tower_hit)
	return value
		

func set_duration(_duration):
	duration = _duration
	$Tags.add_tag($Tags.e_effect.health)
	$Duration.wait_time = duration
	$Duration.start()

func get_description():
	var des = "Add a hot to enemys on deaths"
	return des
