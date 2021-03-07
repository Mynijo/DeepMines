extends "res://buildings/Building.gd"

signal Spawn_Enemy
signal Spawn_Building

var enemys = []
var buliding_on_death = null

func _ready():
	map = get_tree().get_root().get_node("map")
	var _rc
	_rc = self.connect("Spawn_Enemy", map , "_on_Spawn_Enemy")
	_rc = self.connect("Spawn_Building", map , "_on_Spawn_Building")
	
	
func add_spawn_on_kill(var _building):
	buliding_on_death = _building
	
var first = true
func spawn_enemys(var ebene):
	var egg
	
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
		
	enemys = egg.incubate_egg()
		
	for e in enemys:
		e.speed = e.speed * rand_range(0.9, 1.1)
		e.max_health = e.max_health * (1 + ebene * 0.1)
		e.add_spawner(self)
		var effects = map.get_enemy_effects(Global_AStar.level_cor_to_id(level_cor))
		for eff in effects:
			e.add_Status(eff.duplicate())
		emit_signal('Spawn_Enemy', e, pos, cor, level_cor)
		

	
func remove_enemy(var _enemy):
	enemys.erase(_enemy)
	if enemys.empty() and buliding_on_death:
		call_deferred("emit_signal", 'Spawn_Building', buliding_on_death, cor, level_cor)
		queue_free()
	


