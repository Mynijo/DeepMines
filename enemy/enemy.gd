extends KinematicBody2D

signal take_damage
signal health_changed
signal dead

export (int) var speed
export (int) var experience
export (int) var damage
export (int) var gold_value = 5
export (int) var max_health
var health

var last_tower_hit = null
var tags
var dead = false

var velocity = Vector2()

func _ready():
	global_position =  Vector2(0, 120)
		
func spawn(_position):
	global_position = _position
	health = max_health

func control(delta):
	var direction = Vector2(-1, 0)
	var changed_speed = speed			
	velocity = direction * changed_speed * delta * -100
	if $Animation.has_animation('walk'):
		if 	!$Animation.is_playing():
			$Animation.play('walk')		
		if speed != changed_speed:
			$Animation.playback_speed = changed_speed/speed
	
func take_damage(damage):
	if dead or damage == null:
		return	
	health = health - damage
	emit_signal('health_changed',health)	
		
func die():
	if get_parent().player:
		get_parent().player.add_money(gold_value)
	if last_tower_hit:
		last_tower_hit.add_exp(experience)
	dead()
		
func dead():
	dead = true
	queue_free()
	
func _physics_process(delta):
		if dead:
			return
		control(delta)
		move_and_slide(velocity)
		
func get_velocity():
	return velocity


func load_settings(_settings):
	if _settings[0][0]:
		for s in _settings:
			set(s[0],s[1])


func is_Enemy():
	return true
