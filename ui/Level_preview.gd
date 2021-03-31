extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
var map

var leveltype
var level_cor

func _ready():
	map = get_tree().get_root().get_node("Map")


func set_button_size(size):
	$PanelContainer.set_size(size) 
	pass
	
func set_level_cor(_level_cor):
	level_cor = _level_cor

func set_level_type(_leveltype):
	leveltype = _leveltype
	match _leveltype:
		map.e_leveltype.e_normal:
			$PanelContainer/TextureButton.texture_normal = $PanelContainer/TextureButton/Normal.texture
		map.e_leveltype.e_shop:
			$PanelContainer/TextureButton.texture_normal = $PanelContainer/TextureButton/Shop.texture


func _on_TextureButton_pressed():
	map.gen_level(level_cor, leveltype)
	hide()

func disabel():
	$PanelContainer/TextureButton.disabled = true;
	
func enabel():
	$PanelContainer/TextureButton.disabled = false;
