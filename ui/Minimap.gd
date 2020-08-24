extends MarginContainer

export (float) var zoom = 1 setget set_zoom
var zoom_default


onready var grid = $MarginContainer/Grid

var Camera

var grid_scale


func _ready():
	grid_scale = grid.rect_size / (get_viewport_rect().size * zoom)
	Camera =  Player.get_node("Camera")
	zoom_default = zoom
	
func _process(delta):
	for item in  get_tree().get_nodes_in_group("minimap_icons"):
		item.show()
		var local_pos = item.get_parent().global_position - Camera.global_position
		var obj_pos = local_pos * grid_scale + grid.rect_size / 2
		# If marker is outside grid, hide or shrink it.
		if grid.get_rect().has_point(obj_pos + grid.rect_position):
			if item.is_in_group("Enemeys"):
				item.scale = Vector2(1, 1)
			else:
				item.show()
		else:
			if item.is_in_group("Enemeys"):
				item.scale = Vector2(0.75, 0.75)
			else:
				item.hide()

		# Don't draw markers outside grid rectangle.
		obj_pos.x = clamp(obj_pos.x, 0, grid.rect_size.x)
		obj_pos.y = clamp(obj_pos.y, 0, grid.rect_size.y)
		
		var temp = obj_pos +  self.rect_global_position
		item.global_position = obj_pos +  Player.global_position +self.rect_position
		
		item.set_scale(grid_scale)


func set_zoom(value):
	zoom = clamp(value, 0.5, 5)
	grid_scale = grid.rect_size / (get_viewport_rect().size * zoom)
	
func _on_Minimap_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_WHEEL_UP:
			self.zoom += 0.1
		if event.button_index == BUTTON_WHEEL_DOWN:
			self.zoom -= 0.1
