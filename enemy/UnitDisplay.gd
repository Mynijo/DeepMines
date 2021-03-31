extends Node2D

var parent

func _ready():
	parent = get_parent()
	$HealthBar.max_value = parent.max_health
	$HealthLabel.text = String(parent.max_health)
	for node in get_children():
		node.hide()
	pass
	
func _process(_delta):
	global_rotation = 0
	
func update_healthbar(_value):
	if _value > $HealthBar.max_value:
		reset_max_value(_value)		
	if _value < $HealthBar.max_value:
		$HealthBar.show()
		$HealthLabel.show()
	$HealthBar.value = _value
	$HealthLabel.text = String (_value)

func reset_max_value(_max_value):
	$HealthBar.max_value = _max_value
	$HealthLabel.text = String (get_parent().max_health)
