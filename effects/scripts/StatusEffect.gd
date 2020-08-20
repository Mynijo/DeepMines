extends Node

export (float) var duration
var parent
var removed_tags = []

enum e_condition{
	at_life
}

var conditions = []

func _ready():
	if duration != 0 and duration != null:
		$Duration.wait_time = duration
		$Duration.start()
	parent = get_parent().get_parent().get_parent()
	load_condition()
			
func _init():
	pass

	
func effekt(value, tag):
	pass

func _on_Duration_timeout():
	delteYou()
	
func delteYou():
	if get_parent().has_method('remove_Status'):
		get_parent().remove_Status(self)
	if parent.has_method('remove_Status'):
		parent.remove_Status(self)
	queue_free()

func refresh(_obj):
	set_duration(_obj.duration)

func set_duration(_duration):
	duration = _duration
	$Duration.wait_time = duration
	$Duration.start()
	
func remove_tag(_tag):
	$Tags.remove_tag(_tag)

func add_tag(_tag):
	$Tags.add_tag(_tag)

func get_tags():
	return $Tags.get_tags()
	
func has_tag(_tag):
	return $Tags.has_tag(_tag)
	
func add_condition(_condition, _value):
	conditions.append([_condition, _value])

func load_condition():
	if conditions.empty():
		return
	for t in $Tags.get_tags():
		if(t != $Tags.e_effect.init and t!= $Tags.e_effect.buff and t!= $Tags.e_effect.debuff):
			removed_tags.append(t)
			$Tags.remove_tag(t)
	for c in conditions:
		if c[0] == e_condition.at_life:
			parent.connect("health_changed",self, "parent_health_changed")

func parent_health_changed(_health):	
	var value = (conditions[conditions.find(e_condition.at_life)])[1]
	if _health <= parent.max_health * value:
		conditions.erase(conditions[conditions.find(e_condition.at_life)])
		rewrite_tags()
		parent.disconnect("health_changed",self, "parent_health_changed")
		
func load_settings(_settings):
	if _settings[0][0]:
		for s in _settings:
			if s[0] == "condition":
				add_condition(s[1],s[2])
			else:
				set(s[0],s[1])
		
func rewrite_tags():
	if conditions.empty():
		for t in removed_tags:
			removed_tags.erase(t)
			$Tags.add_tag(t)

func has_icon():
	if $Icon.texture:
		return true
	else:
		return false
	
func get_icon():
	if $Icon.texture:
		return  $Icon
	return null
