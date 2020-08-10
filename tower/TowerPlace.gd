extends Node2D
export (PackedScene) var tower
export (PackedScene) var player
export (PackedScene) var attack = preload("res://Attack/Projectile.tscn")

var attackIndex = 0
var accTower

var runes_screen = []

func _ready():
	set_player(get_parent().get_player())
	
func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if !accTower:
				if player.money -50 < 10:
					return
				player.add_money(-50)
				spawn_tower()



func spawn_tower():
		accTower = tower.instance()
		accTower.Attack = attack
		add_child(accTower)
		accTower.spawn(position.normalized())
	

func set_player(_player):
	player = _player
