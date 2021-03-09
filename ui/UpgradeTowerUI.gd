extends PanelContainer

var map
var tower

var open = false


export (PackedScene) var UpgradeSlotScene = preload("res://ui/TowerUpgradeSlot.tscn")
	
signal gameState_changed

func _ready():
	map = get_tree().get_root().get_node("map")
	Global_GameStateManager.connect("gameState_changed", self, "on_gameState_changed")
	
func set_tower(_tower):
	tower = _tower

func on_gameState_changed(_dummy):
	hide()

func show():
	.show()
	refresh_upgrades()
	
func add_upgrade(var upgrade):
	var UpgradeSlot = UpgradeSlotScene.instance()
	UpgradeSlot.set_Upgrade(upgrade)
	$VBoxContainer/SlotContainer.add_child(UpgradeSlot)
	return
	
func align():
	self.rect_global_position.x = -1 * ($VBoxContainer.rect_size.x + 15)/ 2 + tower.global_position.x
	self.rect_global_position.y = tower.global_position.y + 25

func refresh_upgrades():
	for child in $VBoxContainer/SlotContainer.get_children():
		$VBoxContainer/SlotContainer.remove_child(child)
		child.free()
	
	var upgrades = tower.get_possible_upgrades()
	for temp_upgrade in upgrades:
		var upgrade = temp_upgrade.duplicate()
		upgrade.set_tower(tower)
		upgrade.set_UI(self)
		self.add_upgrade(upgrade)
		
	call_deferred("align")
	
	if $VBoxContainer/SlotContainer.get_children().empty():
		self.hide()
