extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (bool) var Mineable  = true
export (bool) var Buildable = false
export (bool) var Walkable = false

enum e_BLOCKS{
	none,
	dirt,
	air,
	pit
}

export (e_BLOCKS) var BlockType = e_BLOCKS.none




var Cor
var Level_cor

var map
# Called when the node enters the scene tree for the first time.
func _ready():
	map = get_tree().get_root().get_node("map")


func set_pos(_cor, _level_cor, _global_position):
	Cor = _cor
	Level_cor = _level_cor
	global_position = _global_position
	

func _on_Block_input_event(_viewport, _event, _shape_idx):
	if (_event is InputEventMouseButton and _event.pressed and _event.button_index == BUTTON_LEFT):
		match Player.current_cursor_mode:
			Player.e_CURSOR_MODE.none:
				return
			Player.e_CURSOR_MODE.Pickaxe:
				if Mineable:
					if Player.get_pickaxe() >= 1:
						var air_block = load("res://terrain/blocks/air.tscn").instance()
						map.replace_block(self, air_block)
						Player.remove_pickaxe(1)
			Player.e_CURSOR_MODE.Shovel:
				if Buildable and BlockType != e_BLOCKS.pit:
					if Player.get_shovel() >= 1:
						var pit_block = load("res://terrain/blocks/pit.tscn").instance()
						if Global_AStar.is_replacement_valid(self, pit_block):
							map.replace_block(self, pit_block)
							queue_free()
							Player.remove_shovel(1)
						else:
							pit_block.queue_free()

			Player.e_CURSOR_MODE.Barricade:
				if Buildable:
					var dirt_block = load("res://terrain/blocks/Dirt.tscn").instance()
					if Global_AStar.is_replacement_valid(self, dirt_block):
						map.replace_block(self, dirt_block)
						queue_free()
					else:
						dirt_block.queue_free()
