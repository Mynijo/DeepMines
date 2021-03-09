extends Node

export (float) var duration
var parent

var removed_tags = []

signal parent_ready

func _ready():
	if duration != 0 and duration != null:
		$Duration.wait_time = duration
		$Duration.start()
	parent = get_parent().get_parent().get_parent()
	emit_signal("parent_ready", self)

func _init():
	pass

	
func effekt(_value, _tag):
	pass

func _on_Duration_timeout():
	delteMe()
	
func delteMe():
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

func load_settings(_settings):
	if _settings.empty():
		return
	for k in _settings.keys():
		set(k ,_settings[k])
		
func add_condition(_condition):
	$Conditions.add_condition(_condition)
	
func get_target():
	return parent
	
func has_icon():
	if $Icon.texture:
		return true
	else:
		return false

func get_description():
	return "description"

func get_icon():
	if $Icon.texture:
		return  $Icon
	return null

func remove_tags():
	for t in $Tags.get_tags():
		if(t != $Tags.e_effect.init and t!= $Tags.e_effect.buff and t!= $Tags.e_effect.debuff):
			removed_tags.append(t)
			$Tags.remove_tag(t)
			
	
func rewrite_tags():
	if $Conditions.get_child_count() == 0:
		for t in removed_tags:
			removed_tags.erase(t)
			$Tags.add_tag(t)

func update_icon(var _new_icon):
	parent.update_icon($Icon,_new_icon)
	$Icon.texture = _new_icon.texture
	
func get_effect_text():
	return String(randi())
