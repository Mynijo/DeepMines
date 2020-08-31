extends Node


signal pick_up_relic
signal player_take_damage
signal player_took_damage
signal gameState_changed



signal update_icon

var map

func _ready():
	map = get_tree().get_root().get_node("map")


func effect(value, tag):
	pass

func update_icon():
	emit_signal('update_icon', self)
	

func has_icon():
	if $Icon.texture:
		return true
	else:
		return false
	
func get_icon():
	if $Icon.texture:
		return  $Icon
	return null

func activate():
	if $Tags.has_tag($Tags.e_relic.pick_up_relic):
		get_parent().connect("pick_up_relic", self, "call_on_pick_up_relic")
	if $Tags.has_tag($Tags.e_relic.pick_up_me):
		get_parent().connect("pick_up_relic", self, "call_on_pick_up_me_calc")
	if $Tags.has_tag($Tags.e_relic.player_take_damage):
		Player.connect("player_take_damage", self, "call_on_player_take_damage")
	if $Tags.has_tag($Tags.e_relic.player_took_damage):
		Player.connect("player_took_damage", self, "call_on_player_took_damage")
	if $Tags.has_tag($Tags.e_relic.game_stat_change):
		Global_GameStateManager.connect("gameState_changed", self, "call_on_gamestate_changed")
		
func deactivate():
	if $Tags.has_tag($Tags.e_relic.pick_up_relic):
		get_parent().disconnect("pick_up_relic", self, "call_on_pick_up_relic")
	if $Tags.has_tag($Tags.e_relic.pick_up_me):
		get_parent().disconnect("pick_up_relic", self, "call_on_pick_up_me_calc")
	if $Tags.has_tag($Tags.e_relic.player_take_damage):
		Player.disconnect("player_take_damage", self, "call_on_player_take_damage")
	if $Tags.has_tag($Tags.e_relic.game_stat_change):
		Global_GameStateManager.disconnect("gameState_changed", self, "call_on_gamestate_changed")
	
func call_on_pick_up_me_calc(var _relic):
	if self == _relic:
		call_on_pick_up_me()
	
	
func call_on_pick_up_me():
	pass
	
func call_on_pick_up_relic():
	pass

func call_on_player_take_damage(var _player):
	pass
	
func call_on_player_took_damage(var _damge):
	pass
	
func call_on_gamestate_changed(var _new_gamestate):
	pass
