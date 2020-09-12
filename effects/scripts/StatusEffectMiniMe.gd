extends "res://effects/scripts/StatusEffect.gd"

signal spawn_MiniMe

export (String) var MiniMePath = "res://Enemy/EnemyBlue.tscn"
var MiniMe
var max_health = 200

var test = 0
var settings = null

func _init():
	$Tags.add_tag($Tags.e_effect.debuff)
	$Tags.add_tag($Tags.e_effect.init)
	$Tags.add_tag($Tags.e_effect.cast_on_death)
	$Tags.add_tag($Tags.e_effect.has_icon)
	
func effekt(value, tag):
	if tag == $Tags.e_effect.init:
		parent = value
	if tag == $Tags.e_effect.cast_on_death:
		var MiniMe = load(MiniMePath)
		self.connect("spawn_MiniMe", self.get_tree().get_current_scene(), "_on_Spawn_Enemy")
		spawm_MiniMe_on_map()
			
func spawm_MiniMe_on_map():
	var MiniMe_ins = MiniMe.instance()
	MiniMe_ins.load_settings(settings)
	emit_signal('spawn_MiniMe', MiniMe_ins, parent.global_position)
	
func load_settings(_settings):
	.load_settings(_settings)
	settings = _settings
