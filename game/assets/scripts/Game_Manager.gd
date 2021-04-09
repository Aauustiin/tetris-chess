extends Node

var level_states = [false, false, false, false, false]
var current_level = 0

func _ready():
	pass 

func set_current_level(x):
	current_level = x

func go_to_level_select():
	get_tree().change_scene("res://assets/scenes/Level_Select.tscn")

func level_complete():
	level_states[current_level] = true
