extends "res://buildings/tower/Tower.gd"


export (int) var charges = 1

func build_me():
	$GunCooldown.wait_time = get_gun_cooldown()
	$DetectRadius/CollisionShape2D.shape = CircleShape2D.new()
	$DetectRadius/CollisionShape2D.shape.radius = get_detect_radius()
	$Node/RayCast2D.cast_to.y = get_detect_radius()


func _process(_delta):	
	if target.size() != 0:
		order_by(e_rule.closest_first)

		$RayCastAnchor.look_at(target.front().global_position)
		ray.force_raycast_update()
		if ray.is_colliding():
			if ray.get_collider().is_in_group("enemys"):
				if can_shoot:
					shoot()
					charges -= 1
					if charges <= 0:
						delete_me()

func delete_me():
	queue_free()
