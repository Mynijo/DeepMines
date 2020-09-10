extends "res://buildings/Building.gd"

var partner

func _ready():
	pass # Replace with function body.

func build_me():	
	pass

func connect_portals(portal):
	var my_node_id = Global_AStar.get_id_of_point(Vector3(cor.x, cor.y, Global_AStar.level_cor_to_id(level_cor)))
	var por_node_id = Global_AStar.get_id_of_point(Vector3(portal.cor.x, portal.cor.y, Global_AStar.level_cor_to_id(portal.level_cor)))
	
	partner = portal
	
	Global_AStar.astar.connect_points(my_node_id, por_node_id, true)


func _on_Building_body_entered(body):
	if body.is_in_group("enemys"):
		if partner:
			var temp_waypoints = body.way_points
			var found_my_pos = false
			var new_waypoint
			var i = 0
			for waypoint in body.way_points:
				i += 1
				if found_my_pos:
					if waypoint[1] == partner.cor and waypoint[2] == partner.level_cor:
						new_waypoint = waypoint
						break
				if waypoint[1] == cor and waypoint[2] == level_cor:
					found_my_pos = true
			
			if new_waypoint:
				body.global_position = new_waypoint[0]
				for _n in range(i):
				 body.way_points.pop_front()
