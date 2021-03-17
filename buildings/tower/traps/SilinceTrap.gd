extends "res://buildings/tower/traps/Trap.gd"

signal spawn_bomb

export (float) var explodeRadius = 100
export (int) var silince_duration = 5
func get_icon():
	return $MapIcon.texture

func build_me():
	#$GunCooldown.wait_time = get_gun_cooldown()
	$DetectRadius/CollisionShape2D.shape = CircleShape2D.new()
	$DetectRadius/CollisionShape2D.shape.radius = get_detect_radius()
	
	deactivate_preview()
	builded = true
	
			
func shoot():
	$Body.hide()
	var _rc
	_rc = self.connect("spawn_bomb", self.get_tree().get_current_scene(), "_on_spawn_attack")
	var RuneSilince = load("res://rune/RuneSilince.tscn").instance()
	RuneSilince.silince_chance = 100
	RuneSilince.silince_duration = silince_duration
	var bomb = load ("res://Attack/StationaryBomb.tscn").instance()
	bomb.effect_damage(0)
	bomb.set_explode_radius(explodeRadius)
	bomb.set_runes([RuneSilince], null)
	bomb.effect_lifetime(0) 
	#bomb.set_explode_animation_scale( Vector2(3,3))
	bomb.set_explode_animation_frames($Animation.frames)
	bomb.set_explode_animation_speed_scale(0.5)
	emit_signal('spawn_bomb', bomb, global_position, self)


func get_description():
	description = "Silince enemey for " + str(silince_duration) + " Seconds"
	return description
