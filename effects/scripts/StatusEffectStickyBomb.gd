extends "res://effects/scripts/StatusEffect.gd"

signal spawn_SoulSplitter

export (int) var StartDmg = 5
export (int) var IncDmg = 5

export (int) var StartExplodeRadius = 50
export (int) var IncExplodeRadius = 5

var percent_dmg
var explodeRadius
var map

signal spawn_bomb

func _init():
	$Tags.add_tag($Tags.e_effect.debuff)
	$Tags.add_tag($Tags.e_effect.init)
	$Tags.add_tag($Tags.e_effect.dont_stack)
	$Tags.add_tag($Tags.e_effect.cast_on_death)
	
func effekt(value, tag):
	if tag == $Tags.e_effect.init:
		parent = value
		percent_dmg = StartDmg
		explodeRadius = StartExplodeRadius
		map = get_tree().get_root().get_node("map")
	if tag == $Tags.e_effect.cast_on_death:
		_on_Duration_timeout_Explode()
		._on_Duration_timeout()

func refresh(_obj):
	.refresh(_obj)	
	percent_dmg += IncDmg
	explodeRadius += IncExplodeRadius


func _on_Duration_timeout_Explode():
	var explodeDamage = parent.max_health / 100 * percent_dmg
	self.connect("spawn_bomb", map, "_on_spawn_attack")
	var bomb = load ("res://Attack/StationaryBomb.tscn").instance()
	bomb.effect_damage(explodeDamage)
	bomb.set_explode_radius(explodeRadius)
	bomb.effect_lifetime(0) 
	bomb.set_explode_animation_scale( Vector2(3,3))
	bomb.set_explode_animation_frames($Animation.frames)
	emit_signal('spawn_bomb', bomb, parent.global_position, parent.last_tower_hit)
