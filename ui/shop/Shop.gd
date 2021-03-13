extends PanelContainer


var traps = []
var relicts = []


func get_all(var path, var ignor):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and not ignor.has(file)  and file.ends_with(".tscn"):
			files.append(path + file)

	dir.list_dir_end()
	return files

func generate_shop():
	traps.clear()
	traps = get_all("res://buildings/tower/traps/", ["Trap.tscn"])
	relicts.clear()
	relicts = get_all("res://relic/", ["Relic.tscn", "Relics.tscn"])
	for child in $VBoxContainer/VBoxContainer/HBoxContainer.get_children():
		$VBoxContainer/VBoxContainer/HBoxContainer.remove_child(child)
		child.queue_free()
		
	for child in $VBoxContainer/VBoxContainer/HBoxContainer2.get_children():
		if child != $VBoxContainer/VBoxContainer/HBoxContainer2/BaseShop:
			$VBoxContainer/VBoxContainer/HBoxContainer2.remove_child(child)
			child.queue_free()
			
	for i in range(3):
		add_random_trap()

	for i in range(2):
		add_ramdom_relict()

	
func add_random_trap():
	var random_trap = traps[randi()  % (traps.size())]
	var slot = load("res://ui/shop/ShopSlot.tscn").instance()
	slot.set_trap(load(random_trap).instance())
	$VBoxContainer/VBoxContainer/HBoxContainer.add_child(slot)

func add_ramdom_relict():
	var random_relict = relicts[randi()  % (relicts.size())]
	relicts.erase(random_relict)
	var slot = load("res://ui/shop/ShopSlot.tscn").instance()
	slot.set_relict(load(random_relict).instance())
	$VBoxContainer/VBoxContainer/HBoxContainer2.add_child(slot)
	reoder_HBoxContainer2()
	
func reoder_HBoxContainer2():
	$VBoxContainer/VBoxContainer/HBoxContainer2.move_child($VBoxContainer/VBoxContainer/HBoxContainer2/BaseShop, 2)


func _on_TextureButtonPickaxe_pressed():
	Player.buy_Pickaxe(1)

func _on_Button_pressed():
	Player.buy_Pickaxe(10)

func _on_TextureButtonBomb_pressed():
	Player.buy_Bombs(1)

func _on_Button2_pressed():
	Player.buy_Bombs(10)

func _on_TextureShovel_pressed():
	Player.buy_Shovel(1)

func _on_Button3_pressed():
	Player.buy_Shovel(10)

func _on_TextureReset_pressed():
	if Player.get_money() >= 50:
		Player.remove_money(50)
		generate_shop()