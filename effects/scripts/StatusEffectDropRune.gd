extends "res://effects/scripts/StatusEffect.gd"

signal spawn_rune

export (String) var rune = null

func _init():
	$Tags.add_tag($Tags.e_effect.cast_on_death)
	$Tags.add_tag($Tags.e_effect.buff)
	$Tags.add_tag($Tags.e_effect.init)
	
	
func effekt(value, tag):
	if tag == $Tags.e_effect.init:
		parent = value
	if tag == $Tags.e_effect.cast_on_death:
		if rune:
			self.connect("spawn_rune", self.get_tree().get_current_scene(), "_on_spawn_rune")
			emit_signal('spawn_rune', load(rune).instance(), parent.global_position)
	return value
