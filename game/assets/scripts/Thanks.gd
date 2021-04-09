extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var xs = get_node("/root/GameManager").level_states
	var flag = true
	for x in xs:
		if x == false:
			flag = false
	if flag == true:
		show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
