extends Node


var tier_eggs = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	var eggs_json = list_files_in_directory('res://enemy/eggs/')
	
	tier_eggs["nomal_egg"] = []
	tier_eggs["small_boss_egg"] = []
	tier_eggs["boss_egg"] = []
	
	tier_eggs["nomal_egg"].append([])
	tier_eggs["nomal_egg"].append([])
	tier_eggs["nomal_egg"].append([])
	tier_eggs["small_boss_egg"].append([])
	tier_eggs["small_boss_egg"].append([])
	tier_eggs["small_boss_egg"].append([])
	tier_eggs["boss_egg"].append([])
	tier_eggs["boss_egg"].append([])
	tier_eggs["boss_egg"].append([])
	
	var egg_inst
	for egg in eggs_json:
		egg_inst = load("res://enemy/EnemyEgg.tscn").instance()
		egg_inst.load_json_egg(egg)
		tier_eggs[egg_inst.get_egg_type()][egg_inst.get_tier() -1].append(egg_inst)


func get_egg(var tier, var small_boss, var boss):
	var egg_type
	var random_num = 0
	
	if small_boss:
		egg_type = "small_boss_egg"
	else: if boss:
		egg_type = "boss_egg"
	else:
		egg_type = "nomal_egg"
	
	if tier_eggs[egg_type][tier -1].size() == 0:
		random_num = 0
	else:
		random_num = randi() % (tier_eggs[egg_type][tier -1].size() -1)
	return tier_eggs[egg_type][tier-1][random_num]


func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(path + file)

	dir.list_dir_end()

	return files
