extends "res://Rune/RuneEffect.gd"

signal shoot

func _init():
	$Tags.add_tag($Tags.e_rune.shoot)
	$Tags.add_tag($Tags.e_rune.init_tower)
	
var counter = 0
var attacks_to_shoot = 2

func effect(_obj, _tag):
	if _tag == $Tags.e_rune.init_tower:
		sort_Obj(_obj)
		self.connect("shoot", tower.get_tree().get_current_scene(), "_on_Tower_shoot")
		$Tags.remove_tag($Tags.e_rune.init_tower)
	if _tag == $Tags.e_rune.shoot:
		if counter < attacks_to_shoot:
			$Timer.start()
		
	

func _on_Timer_timeout():
	tower.shoot()
	counter += 1
	if counter >= attacks_to_shoot:
		counter = 0
		$Timer.stop()
	

