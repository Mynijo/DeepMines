extends Node

var egg_values

# Called when the node enters the scene tree for the first time.
func _ready():
	load_json_egg("res://enemy/eggs/Dragon_Boss.json")
	incubate_egg()
	pass



func incubate_egg():
	var enemys = []
	for enemy_values in egg_values["enemeys"]:
		var test = enemy_values["packed_scene"]
		var enemy = load(enemy_values["packed_scene"]).instance()
		enemy.load_settings(enemy_values["not_default_values"])
		for effect_values in enemy_values["effects"]:
			var effect = load(effect_values["packed_scene"]).instance()
			effect.load_settings(effect_values["not_default_values"])
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
