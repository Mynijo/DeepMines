extends "res://buildings/Building.gd"

func _on_Building_body_entered(body):
	if body.has_method('hit_building_get_dmg') and body.is_in_group("enemys"):
		Player.take_damage(calcDmg(body))
