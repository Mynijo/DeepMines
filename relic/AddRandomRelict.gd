extends "res://relic/Relic.gd"


# Declare member variables here. Examples:
func _init():
	$Tags.add_tag($Tags.e_relic.pick_up_me)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func call_on_pick_up_me():
	var ramdom_relict = get_ramdom_relict()
	if ramdom_relict:
		Player.add_relict(ramdom_relict)

func get_all(var path, var ignor):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and not ignor.has(file)  and file.ends_with(".tscn"):
			files.append(path + file)

	dir.list_dir_end()
	return files

func get_ramdom_relict():
	var relicts = get_all("res://relic/", ["Relic.tscn", "Relics.tscn"])
	if relicts.empty():
		return null
	var random_relict = relicts[randi()  % (relicts.size())]
	var random_relict_obj = load(random_relict).instance()
	relicts.erase(random_relict)
	var relics_name = Player.get_relics_name()
	if relics_name.has(random_relict_obj.get_name()):
		random_relict_obj.free()
		return get_ramdom_relict()
	return random_relict_obj
