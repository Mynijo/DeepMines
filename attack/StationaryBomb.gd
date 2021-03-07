extends "res://attack/StationaryAttack.gd"

func explode():
	var tages = self.get_overlapping_bodies()
	
	for t in tages:
		if t.has_method('take_damage'):
			t.take_damage(calcDmg(t))
		for r in runes:
			if r.has_tag($Tags.e_rune.enemy_was_dmg):
				r.effect(t,$Tags.e_rune.enemy_was_dmg)	
		if tower:
			if t.has_method("set_last_tower_hit"):
				t.set_last_tower_hit(tower)
		for r in runes:
			if r.has_tag($Tags.e_rune.enemy_was_hit):			
				if !r.effect(t, $Tags.e_rune.enemy_was_hit): # continue?
					return
						
	for r in runes:
		var temp = r.get_tags()
		if r.has_tag($Tags.e_rune.explode):
			if !r.effect(self, $Tags.e_rune.explode):
				return
				
	if $ExplodeAnimation:
		$ExplodeAnimation.play("explosion")
	else:
		queue_free()
		
func set_explode_radius(_radius):
	$CollisionShape2D.shape.radius = _radius

func set_explode_animation_scale(_scale):
	$ExplodeAnimation.scale = _scale
	
func set_explode_animation_frames(_explode_animation_frames):
	$ExplodeAnimation.frames = _explode_animation_frames
	
func set_explode_animation_speed_scale(_speed_scale):
	$ExplodeAnimation.speed_scale = _speed_scale

func _on_ExplodeAnimation_animation_finished():
	queue_free()
