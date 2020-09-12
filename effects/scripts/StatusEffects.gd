extends Node

var saved_tags = []

func _ready():
	pass
	
func add_Status(_status):
	if _status.has_tag($Tags.e_effect.dont_stack):
		for x in get_Status_list():
			if x.name.is_subsequence_of(_status.name):
				if x.has_tag($Tags.e_effect.dont_stack):
					x.refresh(_status) 
					_status.queue_free()
					return
	
	if _status.has_tag($Tags.e_effect.has_icon):
		get_parent().add_Status_Icon(_status)
	
	if _status.has_tag($Tags.e_effect.buff):
		$Buffs.add_child(_status)
	if _status.has_tag($Tags.e_effect.debuff):
		$Debuffs.add_child(_status)
		
	if get_parent().spawned and _status.has_tag($Tags.e_effect.init):
		_status.effekt(get_parent(), $Tags.e_effect.init)
	return
		
func get_Status_list(_tag = null):
	var status_list = []	
	for s in $Buffs.get_children():
		if _tag == null or s.has_tag(_tag):
			status_list.append(s)
	for s in $Debuffs.get_children():
		if _tag == null or s.has_tag(_tag):
			status_list.append(s)
	return status_list

func remove_Status(_status):
	if _status.has_tag($Tags.e_effect.buff):
		$Buffs.remove_child(_status)
	else:
		if _status.has_tag($Tags.e_effect.debuff):
			$Debuffs.remove_child(_status)
	_status.queue_free()
	
