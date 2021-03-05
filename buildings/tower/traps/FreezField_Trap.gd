extends "res://buildings/tower/traps/Trap.gd"

func get_icon():
	return $MapIcon.texture

func build_me():
	$GunCooldown.wait_time = get_gun_cooldown()
	$DetectRadius/CollisionShape2D.shape = CircleShape2D.new()
	$DetectRadius/CollisionShape2D.shape.radius = get_detect_radius()
	
	map = get_tree().get_root().get_node("map")
	var run = load("res://rune/RunePierce.tscn").instance()
	run.set_max_pierce(50)
	runes_attached.append(run)
	
	var RuneAddSlow = load("res://Rune/RuneAddSlow.tscn").instance()
	runes_attached.append(RuneAddSlow)
	
	var RuneWhirl = load("res://Rune/RuneWhirl.tscn").instance()
	runes_attached.append(RuneWhirl)
	
	emit_signal('Runes_Changed')
	deactivate_preview()
	builded = true
	
var triggerd = false
func _process(_delta):
	if target.size() != 0:
		triggerd = true
	if triggerd:
		$Body.hide()
		if can_shoot:
			for x in range(0,6):
				rotation = x
				shoot()
			charges -= 1
			if charges <= 0:
				delete_me()
