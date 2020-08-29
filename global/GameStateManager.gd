extends Node2D



enum e_GAMESTATE{
	none,
	build_phase,
	battel_phase
}

var game_stat = e_GAMESTATE.none



var map

func _ready():
	map = get_tree().get_root().get_node("map")
	
	
func change_game_state(var _new_stat):
	if game_stat == _new_stat:
		return
	game_stat = _new_stat
	match game_stat:
		e_GAMESTATE.battel_phase:
			map.hide_gen_buttons()
			Player._on_Cursor_Mode_None_pressed()
			Player.disable_Mode_Buttons()
		e_GAMESTATE.build_phase:
			map.show_gen_buttons()
			Player.enable_Mode_Buttons()
