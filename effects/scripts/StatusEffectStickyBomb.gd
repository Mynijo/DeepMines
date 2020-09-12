extends "res://effects/scripts/StatusEffect.gd"

signal spawn_SoulSplitter

export (int) var StartDmg = 5
export (int) var IncDmg = 5

export (int) var StartExplodeRadius = 10
export (int) var IncExplodeRadius = 5

var percent_dmg
var explodeRadius
var map

var explode_animation_scale = Vector2(0.5,0.5)

signal spawn_bomb

func _init():
	$Tags.add_tag($Tags.e_effect.debuff)
	$Tags.add_tag($Tags.e_effect.init)
	$Tags.add_tag($Tags.e_effect.dont_stack)
	$Tags.add_tag($Tags.e_effect.cast_on_death)
	$Tags.add_tag($Tags.e_effect.has_icon)
	
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
	change_icon()


func _on_Duration_timeout_Explode():
	var explodeDamage = parent.max_health / 100 * percent_dmg
	self.connect("spawn_bomb", map, "_on_spawn_attack")
	var bomb = load ("res://Attack/StationaryBomb.tscn").instance()
	bomb.effect_damage(explodeDamage)
	bomb.set_explode_radius(explodeRadius)
	bomb.effect_lifetime(0) 
	bomb.set_explode_animation_scale(explode_animation_scale)
	bomb.set_explode_animation_frames($Animation.frames)
	emit_signal('spawn_bomb', bomb, parent.global_position, parent.last_tower_hit)
	
func change_icon():
	if percent_dmg < 10:
		update_icon($Icon01)
		explode_animation_scale = Vector2(0.5,0.5)
	else: if percent_dmg < 20:
		update_icon($Icon02)
		explode_animation_scale = Vector2(1,1)
	else: if percent_dmg < 50:
		update_icon($Icon03)
		explode_animation_scale = Vector2(2,2)
	else:
		update_icon($Icon04)
		explode_animation_scale = Vector2(3,3)
	
