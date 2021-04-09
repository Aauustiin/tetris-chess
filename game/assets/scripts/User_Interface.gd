extends Control

onready var game_manager = get_node("/root/GameManager")

func _ready():
	pass 

func unpause():
	get_tree().paused = false
	$Menu.hide()

# Handling button presses in pause menu

func _on_Pause_Button_pressed():
	get_tree().paused = true
	$Menu.show()

func _on_Resume_pressed():
	unpause()

func _on_Restart_pressed():
	unpause()
	get_node("/root/Node2D/Board").restart()

func _on_Quit_pressed():
	unpause()
	game_manager.go_to_level_select()

# Displaying signals from Board

func _on_Board_invalid_move():
	$Label.text = "Invalid Move"
	$Label.show()
	yield(get_tree().create_timer(1.0), "timeout")
	$Label.hide()

func _on_Board_victory():
	$Label.text = "You Win!"
	$Label.show()
	yield(get_tree().create_timer(3.0), "timeout")
	$Label.hide()

func _on_Board_defeat():
	$Label.text = "You Lose!"
	$Label.show()
	yield(get_tree().create_timer(1.0), "timeout")
	$Label.hide()
