extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var cell_width

# Called when the node enters the scene tree for the first time.
func _ready():
	cell_width = get_node("Sprite").texture.get_size()[0]/8
	get_node("Sprite2").set_position( Vector2(cell_width/2, cell_width/2) )
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				var click_position = event.position - get_position()
				var clicked_cell_coords = Vector2(int(floor(click_position[0]/cell_width)), int(floor(click_position[1]/cell_width)))
				get_node("Sprite2").set_position( clicked_cell_coords[0]*Vector2(cell_width, 0) + clicked_cell_coords[1]*Vector2(0, cell_width) + Vector2(cell_width/2, cell_width/2))
				print(clicked_cell_coords)
	pass # Replace with function body.
