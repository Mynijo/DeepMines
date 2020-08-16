extends "res://buildings/Building.gd"

signal Spawn_Enemy
signal Spawn_Building

var enemys = []

var buliding_on_death = null

func _ready():
	player = get_tree().get_root().get_node("map").get_player()
	self.connect("Spawn_Enemy", get_tree().get_root().get_node("map"), "_on_Spawn_Enemy")
	self.connect("Spawn_Building", get_tree().get_root().get_node("map"), "_on_Spawn_Building")
	
func add_spawn_on_kill(var _building):
	buliding_on_death = _building
	

func spawn_enemys(var ebene):
	var e = load("res://enemy/enemys/Goblin.tscn").instance()
	emit_signal('Spawn_Enemy', e, pos, cor)
	e.add_spawner(self)
	enemys.append(e)
	
func remove_enemy(var _enemy):
	enemys.erase(_enemy)
	if enemys.empty() and buliding_on_death:
		emit_signal('Spawn_Building', buliding_on_death, cor)
		queue_free()
	


