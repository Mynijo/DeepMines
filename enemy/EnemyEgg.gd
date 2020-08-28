extends Node

var egg_values

# Called when the node enters the scene tree for the first time.
func _ready():	
	pass

func get_tier():
	return egg_values["tier"]
	
func get_egg_type():
	if is_small_boss():
		return "small_boss_egg"
	if is_boss():
		return "boss_egg"
	return "nomal_egg"
	
func is_small_boss():
	if egg_values.has("small_boss"):
		return egg_values["small_boss"]
	return false
 
func is_boss():
	if egg_values.has("boss"):
		return egg_values["boss"]
	return false

func incubate_egg():
	var enemys = []
	for enemy_values in egg_values["enemeys"]:
		var test = enemy_values["packed_scene"]
		var enemy = load(enemy_values["packed_scene"]).instance()
		enemy.load_settings(enemy_values["not_default_values"])
		for effect_values in enemy_values["effects"]:
			var effect = load(effect_values["packed_scene"]).instance()
			effect.load_settings(effect_values["not_default_values"])
			for condition_values in effect_values["conditions"]:
				var condition = load(condition_values["packed_scene"]).instance()
				condition.load_settings(condition_values["not_default_values"])
				effect.add_condition(condition)
			enemy.add_Status(effect)
		enemys.append(enemy)
	return enemys


func load_json_egg(path):
	var file = File.new()
	file.open(path, file.READ)    
	var tmp_text = file.get_as_text()
	file.close()    
	egg_values = parse_json(tmp_text)
	pass
