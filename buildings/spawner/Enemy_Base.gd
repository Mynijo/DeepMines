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
	var egg
	var enemeys
	
	if ebene < 5:
		egg = Global_EggManager.get_egg(1, false, false)
	else: if ebene == 5:
		egg = Global_EggManager.get_egg(1, true, false)
	else: if ebene  < 10:
		egg = Global_EggManager.get_egg(1, false, false)
	else: if ebene == 10:
		egg = Global_EggManager.get_egg(1, false, true)
	else: if ebene < 15:
		egg = Global_EggManager.get_egg(2, false, false)
	else: if ebene == 15:
		egg = Global_EggManager.get_egg(2, true, false)
	else: if ebene  < 20:
		egg = Global_EggManager.get_egg(2, false, false)
	else: if ebene == 20:
		egg = Global_EggManager.get_egg(2, false, true)
	else: if ebene < 25:
		egg = Global_EggManager.get_egg(3, false, false)
	else: if ebene == 25:
		egg = Global_EggManager.get_egg(3, true, false)
	else: if ebene  < 30:
		egg = Global_EggManager.get_egg(3, false, false)
	else: if ebene == 30:
		egg = Global_EggManager.get_egg(3, false, true)
	else:
		egg = Global_EggManager.get_egg(3, false, false)
		
	enemeys = egg.incubate_egg()
		
	for e in enemeys:
		e.speed = e.speed * rand_range(0.9, 1.1)
		e.add_spawner(self)
		emit_signal('Spawn_Enemy', e, pos, cor, level_cor)
		

	
func remove_enemy(var _enemy):
	enemys.erase(_enemy)
	if enemys.empty() and buliding_on_death:
		call_deferred("emit_signal", 'Spawn_Building', buliding_on_death, cor, level_cor)
		queue_free()
	


