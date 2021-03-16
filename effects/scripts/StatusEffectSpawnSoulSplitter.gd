extends "res://effects/scripts/StatusEffect.gd"

signal spawn_SoulSplitter

export (String) var EnemyPath = "res://enemy/enemys/SoulSplitter.tscn"
var enemy
var max_health = 200

var test = 0
var settings = null

func _init():
	$Tags.add_tag($Tags.e_effect.debuff)
	$Tags.add_tag($Tags.e_effect.init)
	$Tags.add_tag($Tags.e_effect.took_dmg)
	$Tags.add_tag($Tags.e_effect.has_icon)
	
func effekt(value, tag):
	if tag == $Tags.e_effect.init:
		parent = value
		self.connect("spawn_SoulSplitter", self.get_tree().get_current_scene(), "_on_Spawn_Enemy")
		enemy = load(EnemyPath)
	if tag == $Tags.e_effect.took_dmg:
		var EnemyPath_ins = enemy.instance()
		EnemyPath_ins.max_health = 1
		call_deferred("emit_signal", 'spawn_SoulSplitter', EnemyPath_ins, parent.global_position, parent.way_points[0][1], parent.way_points[0][2])
		return value
	
func load_settings(_settings):
	.load_settings(_settings)
	settings = _settings

func get_description():
	var des = "Everytime the enemy gets dmg, a SoulSplitter with 1 hp will be spawnt"
	return des
