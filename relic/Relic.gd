extends Node


signal pick_up_relic
signal player_take_damage
signal player_took_damage
signal gameState_changed
signal player_heal
signal player_healed

export (String) var relict_name = "dummy_name"
export (String) var description = "dummy_description"
export (int) var price = 100

signal update_icon

var map

func _ready():
	map = get_tree().get_root().get_node("map")

func get_name():
	return relict_name

func get_price():
	return price

func effect(_value, _tag):
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
	var _rc
	if $Tags.has_tag($Tags.e_relic.pick_up_relic):
		_rc = get_parent().connect("pick_up_relic", self, "call_on_pick_up_relic")
	if $Tags.has_tag($Tags.e_relic.pick_up_me):
		_rc = get_parent().connect("pick_up_relic", self, "call_on_pick_up_me_calc")
	if $Tags.has_tag($Tags.e_relic.player_take_damage):
		_rc = Player.connect("player_take_damage", self, "call_on_player_take_damage")
	if $Tags.has_tag($Tags.e_relic.player_took_damage):
		_rc = Player.connect("player_took_damage", self, "call_on_player_took_damage")
	if $Tags.has_tag($Tags.e_relic.player_heal):
		_rc = Player.connect("player_heal", self, "call_on_player_heal")
	if $Tags.has_tag($Tags.e_relic.player_healed):
		_rc = Player.connect("player_healed", self, "call_player_healed")
	if $Tags.has_tag($Tags.e_relic.game_stat_change):
		_rc = Global_GameStateManager.connect("gameState_changed", self, "call_on_gamestate_changed")
		
func deactivate():
	if $Tags.has_tag($Tags.e_relic.pick_up_relic):
		get_parent().disconnect("pick_up_relic", self, "call_on_pick_up_relic")
	if $Tags.has_tag($Tags.e_relic.pick_up_me):
		get_parent().disconnect("pick_up_relic", self, "call_on_pick_up_me_calc")
	if $Tags.has_tag($Tags.e_relic.player_take_damage):
		Player.disconnect("player_take_damage", self, "call_on_player_take_damage")
	if $Tags.has_tag($Tags.e_relic.player_took_damage):
		Player.disconnect("player_took_damage", self, "call_on_player_took_damage")
	if $Tags.has_tag($Tags.e_relic.player_heal):
		Player.disconnect("player_heal", self, "call_on_player_heal")
	if $Tags.has_tag($Tags.e_relic.player_healed):
		Player.disconnect("player_healed", self, "call_player_healed")
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
	
func call_on_player_heal(var _player):
	pass
	
func call_on_player_healed(var _damge):
	pass
	
func call_on_gamestate_changed(var _new_gamestate):
	pass

func _on_Icon_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT and event.pressed:
			Player.show_relic_preview(relict_name,get_icon().texture,get_description())


func is_buyable():
	if $Tags.has_tag($Tags.e_relic.not_buyable):
		return false
	return true
	 

func get_description():
	return description
