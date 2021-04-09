extends TextureButton

onready var game_manager = get_node("/root/GameManager")

func _ready():
	pass

func _on_Play_pressed():
	game_manager.go_to_level_select()
