extends "res://buildings/Building.gd"


export (PackedScene) var tower
export (PackedScene) var attack = preload("res://Attack/Projectile.tscn")

var attackIndex = 0
var accTower

var runes_screen = []

func spawn_tower():
		accTower = tower.instance()
		accTower.Attack = attack
		add_child(accTower)
		accTower.spawn(position.normalized())
	


func _on_Building_input_event(_viewport, _event, _shape_idx):
	if Global_GameStateManager.game_stat == Global_GameStateManager.e_GAMESTATE.build_phase:
		if _event is InputEventMouseButton and _event.pressed:
			if _event.button_index == BUTTON_LEFT and _event.pressed:
				if !accTower:
					if Player.get_money() -50 < 0:
						return
					Player.add_money(-50)
					spawn_tower()
					$Cost.hide()



func _on_Building_body_entered(_body):
	pass # Replace with function body.


func _on_Building_mouse_exited():
	pass # Replace with function body.
