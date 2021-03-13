extends "res://effects/scripts/StatusEffect.gd"

signal spawn_SoulSplitter

export (String) var PortalPath = "res://buildings/Teleporter.tscn"
var enemy
var max_health = 200

var test = 0
var settings = null
var map

func _init():
	$Tags.add_tag($Tags.e_effect.debuff)
	$Tags.add_tag($Tags.e_effect.init)
	$Tags.add_tag($Tags.e_effect.took_dmg)
	$Tags.add_tag($Tags.e_effect.has_icon)
	
func effekt(value, tag):
	if tag == $Tags.e_effect.init:
		parent = value
		map = get_tree().get_root().get_node("map")
	if tag == $Tags.e_effect.took_dmg:
		var way_poins_size = parent.way_points.size()
		if way_poins_size > 12:
			var rand_waypoint = int(rand_range(5, way_poins_size /2))
			
			var waypoints = parent.way_points
			
			var portal1_pos = waypoints[0]
			var portal2_pos = waypoints[rand_waypoint]
			
			var portal = load(PortalPath)
			var portal1 = portal.instance()
			var portal2 = portal.instance()
			
			map.call_deferred ("add_building",portal1, portal1_pos[1],  portal1_pos[2])
			map.call_deferred ("add_building",portal2, portal2_pos[1],  portal2_pos[2])
			
			portal1.call_deferred ("connect_portals",portal2)
		
		
		delteMe()
		return value

func get_description():
	var des = "First time Enemy take dmg, it will spawn a Portal. Portal will be used by outer Enemys"
	return des
