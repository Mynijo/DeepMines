extends "res://buildings/Building.gd"

signal Spawn_Enemy
signal Spawn_Building

var enemys = []

var buliding_on_death = null

func _ready():
	self.connect("Spawn_Enemy", get_tree().get_root().get_node("map"), "_on_Spawn_Enemy")
	self.connect("Spawn_Building", get_tree().get_root().get_node("map"), "_on_Spawn_Building")
	
	
func add_spawn_on_kill(var _building):
	buliding_on_death = _building
	
var first = true
func spawn_enemys(var ebene):
	for i in (ebene +1):
		var e 
		var status
		var status2
		if first:
			e = load("res://enemy/enemys/jinn.tscn").instance()
			status = load("res://effects/StatusEffectCharge.tscn").instance()
			emit_signal('Spawn_Enemy', e, pos, cor, level_cor)
			e.add_Status(status)
			first = false
		else:
			e = load("res://enemy/enemys/dragon.tscn").instance()
			status = load("res://effects/StatusEffectHoT.tscn").instance()
			status2 = load("res://effects/StatusEffectMoveOnFullLive.tscn").instance()
			emit_signal('Spawn_Enemy', e, pos, cor, level_cor)
			e.add_Status(status)
			e.add_Status(status2)
			
		
		e.max_health = int(e.max_health * rand_range(0.95, 1.05))
		e.speed = e.speed * rand_range(0.95, 1.05)
		e.add_spawner(self)
		enemys.append(e)
	
func remove_enemy(var _enemy):
	enemys.erase(_enemy)
	if enemys.empty() and buliding_on_death:
		call_deferred("emit_signal", 'Spawn_Building', buliding_on_death, cor, level_cor)
		queue_free()
	


