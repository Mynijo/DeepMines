extends Node

export (String) var description = "Dummy"
export (float) var duration
var interal_duration = duration
var parent

var removed_tags = []

signal parent_ready

func _ready():
	start_duration()
	parent = get_parent().get_parent().get_parent()
	emit_signal("parent_ready", self)

func _init():
	pass

func get_duration():
	return duration

func stop_duration():
	$Duration.stop()
	
func start_duration():
	if interal_duration != 0 and interal_duration != null:
		$Duration.wait_time = interal_duration
		$Duration.start()
		
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
	set_duration(_obj.interal_duration)

func set_duration(_duration):
	interal_duration = _duration
	
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

func get_icon():
	if $Icon.texture:
		return  $Icon
	return null

func remove_tags():
	for t in $Tags.get_tags():
		if(t != $Tags.e_effect.init and t != $Tags.e_effect.has_icon and t!= $Tags.e_effect.buff and t!= $Tags.e_effect.debuff):
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

func get_description():
	return description

func get_full_description():
	var des = get_description()
	for condition in $Conditions.get_children():
		des = des + " " +condition.get_condition_text()
	if duration > 0: 
		des = des + " Duration: " + str(duration) + "S"
	return des
