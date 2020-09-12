extends "res://effects/scripts/StatusEffect.gd"


export (PackedScene) var attack
var first_time = true

signal shoot


func _init():
	$Tags.add_tag($Tags.e_effect.speed)
	$Tags.add_tag($Tags.e_effect.cast_on_death)
	$Tags.add_tag($Tags.e_effect.animation)
	$Tags.add_tag($Tags.e_effect.dont_stack)
	$Tags.add_tag($Tags.e_effect.debuff)	
	$Tags.add_tag($Tags.e_effect.init)
	$Tags.add_tag($Tags.e_effect.has_icon)
	
func effekt(value, tag):
	if tag == $Tags.e_effect.init:
		parent = value
	if first_time:
		first_time = false		
	if tag == $Tags.e_effect.speed:
		return 0
	if tag == $Tags.e_effect.cast_on_death:		
		shoot()
	if tag == $Tags.e_effect.animation:
		$Animation.global_position = value.global_position
		$Animation.show()
		$Animation.play("freeze")
		return
	return value
	
		
		
func _on_Duration_timeout():
	.delteMe()
	
func shoot():
	self.connect("shoot", self.get_tree().get_current_scene(), "_on_Tower_shoot")
	var RuneAddSlow = load("res://Rune/RuneAddSlow.tscn")
	var RuneWhirl = load("res://Rune/RuneWhirl.tscn")
	var b 
	var dir
	var runnes = []
	
	for x in range(0,6):
		dir = Vector2(1, 0).rotated(x)
		b = attack.instance()
		runnes.clear()
		runnes.append( RuneAddSlow.instance())
		runnes.append( RuneWhirl.instance())		
		b.get_node("Sprite").texture = $Ice.texture
		b.get_node("Sprite").region_enabled  = false
		b.set_runes(runnes, b)
		b.runes[0].remove_tag($Tags.e_rune.process_animation)
		b.effect_lifetime(2) 
		b.effect_speed(b.get_speed()/2)
		b.damage = 0
		emit_signal('shoot', b, parent.global_position, dir,parent.last_tower_hit)
		for r in runnes:
			r.queue_free()
