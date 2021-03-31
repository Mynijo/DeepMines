extends TileMap

class block:	
	var block_name: String
	var mineable: bool
	var buildable: bool
	var walkable: bool
	var digable: bool
	var bombable: bool

var map
# Called when the node enters the scene tree for the first time.
func _ready():
	map = get_tree().get_root().get_node("Map")
	
	
func test(tile_cor):
	var id1 = Global_AStar.get_id_of_point(Vector3(map.heart_cor.x, map.heart_cor.y, 0))
	var id2 = Global_AStar.get_id_of_point(Vector3(tile_cor.x, tile_cor.y, 0))
	var path = Global_AStar.get_id_path(id1, id2)
	
	for id in path:
		Player.add_debug(map.gen_lvl_id_to_cor(id))


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var tile_cor = world_to_map(Player.get_global_mouse_position())
			var tile = get_cellv(tile_cor)
			var block = map.block_typs[tile]
			Player.add_debug(tile_cor)
			test(tile_cor)
			match Player.current_cursor_mode:
				Player.e_CURSOR_MODE.None:
					return
				Player.e_CURSOR_MODE.Pickaxe:
					if block.mineable:
						if Player.get_pickaxe() >= 1:
							set_cellv(tile_cor, 1)
							update_neighbour(tile_cor)
							Player.remove_pickaxe(1)
							Global_AStar.recalc(tile_cor)
				Player.e_CURSOR_MODE.Shovel:
					if block.digable:
						if Player.get_shovel() >= 1:
							if Global_AStar.is_disable_valid(tile_cor):
								set_cellv(tile_cor, 2)
								Player.remove_shovel(1)
								update_neighbour(tile_cor)
								Global_AStar.recalc(tile_cor)
				Player.e_CURSOR_MODE.Bomb:
					if block.bombable:
						if Player.get_bombs() >= 1:
							if Global_AStar.is_disable_valid(tile_cor):
								set_cellv(tile_cor, 0)
								Player.remove_bombs(1)
								update_neighbour(tile_cor)
								Global_AStar.recalc(tile_cor)
			
func update_neighbour(cor):
	update_bitmask_region(cor - Vector2(1,1) ,cor + Vector2(1,1))
