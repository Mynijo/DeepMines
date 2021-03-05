extends HBoxContainer


export (NodePath) var Relics_Path

var Relics_Node

#signal pick_up_relic
#signal update_icon

var relics = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	Relics_Node = get_node(Relics_Path)
	if Relics_Node:
		Relics_Node.connect("pick_up_relic", self, "call_on_pick_up_relic")		


func call_on_pick_up_relic(_relic):
	if _relic.has_icon():
		add_Status_Icon(_relic)
	_relic.connect("update_icon", self, "call_on_update_icon")		

func add_Status_Icon(_relic):
	var icon = _relic.get_icon().duplicate()
	relics[_relic.get_instance_id()] = icon
	add_child(icon)
	icon.visible = true


func call_on_update_icon(_relic):
	if relics.has(_relic.get_instance_id()):
		var old_icon = relics[_relic.get_instance_id()]
		var pos_of_old_icon = old_icon.get_position_in_parent()
		var new_icon = _relic.get_icon().duplicate()
		remove_child(old_icon)
		old_icon.free()
		add_child(new_icon)
		move_child(new_icon, pos_of_old_icon)
		relics[_relic.get_instance_id()] = new_icon
		new_icon.visible = true
	else:
		add_Status_Icon(_relic)
