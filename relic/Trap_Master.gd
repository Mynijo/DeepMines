extends "res://relic/Relic.gd"

var traps = []


# Declare member variables here. Examples:
func _init():
	$Tags.add_tag($Tags.e_relic.pick_up_me)
	$Tags.add_tag($Tags.e_relic.game_stat_change)
	var traps_paths = get_all_traps();
	
	for trap_path in traps_paths:
		traps.append(load(trap_path))
	
	
func _ready():
	pass # Replace with function body.


func call_on_pick_up_me():
	call_deferred("add_traps", 10)
	
func call_on_gamestate_changed(var _new_gamestate):
	if(_new_gamestate == Global_GameStateManager.e_GAMESTATE.build_phase):
		call_deferred("add_traps", 5)
	
	
func add_traps(counter):
	for i in counter:
		add_trap()
		
func add_trap():	
	var buildable_blocks = []
	var all_blocks = map.get_blocks()
	for block in all_blocks:
		if(block.Buildable):
			buildable_blocks.append(block)
	
	var random_block = buildable_blocks[randi() % (buildable_blocks.size())]
	var random_trap = traps[randi()  % (traps.size())]
	
	random_block.build_trap(random_trap.instance())
	
func get_all_traps():
	var path = "res://buildings/tower/traps/"
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file != "Trap.tscn" and file.ends_with(".tscn"):
			files.append(path + file)

	dir.list_dir_end()

	return files
	
