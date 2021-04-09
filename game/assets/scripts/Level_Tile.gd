extends Area2D

export var Level = 1
export var Level_Name = "Level"

func _ready():
	if get_node("/root/GameManager").level_states[Level-1]:
		$Sprite.show()


func _on_1_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				get_node("/root/GameManager").set_current_level(Level-1)
				get_tree().change_scene("res://assets/scenes/"+Level_Name+".tscn")
