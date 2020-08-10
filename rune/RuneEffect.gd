extends Node

var attack
var tower
	
func effect(_obj, _tag):
	pass
	
func get_tags():
	return $Tags.get_tags()
	
func has_tag(_tag):
	return $Tags.has_tag(_tag)
	
func add_tag(_tag):
	return $Tags.add_tag(_tag)
	
func remove_tag(_tag):
	return $Tags.remove_tag(_tag)
	
func sort_Obj(_obj):
	if _obj:
		if !tower or true:
			if _obj.has_method('is_Tower'):
				tower = _obj
				return
		if !attack:
			if _obj.has_method('is_Attack'):
				attack = _obj
				return
