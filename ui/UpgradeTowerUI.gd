extends PanelContainer

var map
var tower

var open = false


export (PackedScene) var UpgradeSlotScene = preload("res://ui/TowerUpgradeSlot.tscn")

func _ready():
	var _rc
	map = get_tree().get_root().get_node("map")
	_rc = Global_GameStateManager.connect("gameState_changed", self, "on_gameState_changed")
	_rc = Player.connect("current_cursor_mode_changed", self, "on_current_cursor_mode_changed")
	
func set_tower(_tower):
	tower = _tower

func on_gameState_changed(_dummy):
	hide()

func show():
	.show()
	refresh_upgrades()
	
func add_upgrade(var _rune):
	var UpgradeSlot = UpgradeSlotScene.instance()
	UpgradeSlot.set_tower(tower)
	UpgradeSlot.set_rune(_rune)
	UpgradeSlot.set_UI(self)
	$VBoxContainer/SlotContainer.add_child(UpgradeSlot)
	return
	
func align():
	self.rect_global_position.x = -1 * ($VBoxContainer.rect_size.x + 15)/ 2 + tower.global_position.x
	self.rect_global_position.y = tower.global_position.y + 25

func refresh_upgrades():
	for child in $VBoxContainer/SlotContainer.get_children():
		$VBoxContainer/SlotContainer.remove_child(child)
		child.free()
	
	var runes = tower.get_possible_upgrades()
	for rune in runes:
		self.add_upgrade(rune)
		
	call_deferred("align")
	
	if $VBoxContainer/SlotContainer.get_children().empty():
		self.hide()

func on_current_cursor_mode_changed():
	self.hide()
