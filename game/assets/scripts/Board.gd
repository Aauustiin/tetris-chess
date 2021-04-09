extends Area2D

onready var game_manager = get_node("/root/GameManager")

enum PIECES{
	PAWN,
	KNIGHT,
	BISHOP,
	ROOK,
	QUEEN,
	KING
}

var piece_texture_map = []
var turn = 0
var cell_size
var valid_moves
var move_indicators = []
var initial_player_coords

export var piece_queue = []
export var player_coords = Vector2(0, 0)
export var king_coords = Vector2(7, 7)

var dot_texture

var board_sprite
var player_sprite
var king_sprite
var queue_sprite
var queue_piece_sprites

signal victory
signal defeat
signal invalid_move

func _ready():
	initial_player_coords = player_coords
	initialise_sprite_references()
	initialise_piece_texture_map()
	dot_texture = load("res://assets/textures/Dot.png")
	cell_size = $Board_Collision.get_shape().get_extents()[0]/4
	initialise_sprites()
	initialise_queue_piece_sprites()
	get_valid_moves(piece_queue[turn])
	make_move_indicators()

# Initialises the position and texture of the player and king sprites.
func initialise_sprites():
	player_sprite.set_position(cell_size*player_coords + Vector2(cell_size/2, cell_size/2))
	king_sprite.set_position(Vector2(king_coords[0]*cell_size, king_coords[1]*cell_size) + Vector2(cell_size/2, cell_size/2))
	player_sprite.set_texture(piece_texture_map[piece_queue[0]])
	pass

func initialise_piece_texture_map():
	piece_texture_map.resize(6)
	piece_texture_map[PIECES.PAWN] = load("res://assets/textures/Pawn.png")
	piece_texture_map[PIECES.KNIGHT] = load("res://assets/textures/Knight.png")
	piece_texture_map[PIECES.BISHOP] = load("res://assets/textures/Bishop.png")
	piece_texture_map[PIECES.ROOK] = load("res://assets/textures/Rook.png")
	piece_texture_map[PIECES.QUEEN] = load("res://assets/textures/Queen.png")
	piece_texture_map[PIECES.KING] = load("res://assets/textures/White_King.png")
	pass

func initialise_sprite_references():
	board_sprite = get_node("Board_Sprite")
	player_sprite = get_node("Player_Sprite")
	king_sprite = get_node("King_Sprite")
	queue_sprite = get_node("Queue_Sprite")
	pass

func initialise_queue_piece_sprites():
	queue_piece_sprites = []
	queue_piece_sprites.resize(piece_queue.size())
	for i in piece_queue.size():
		queue_piece_sprites[i] = Sprite.new()
		add_child(queue_piece_sprites[i])
		queue_piece_sprites[i].texture = piece_texture_map[piece_queue[i]]
		queue_piece_sprites[i].position = Vector2(9.5*cell_size, (7.5-i)*cell_size)

func get_valid_moves(piece):
	var moves = []
	match piece:
		PIECES.PAWN:
			if king_coords-player_coords != Vector2(0, -1):
				moves.append(player_coords + Vector2(0, -1))
			if (king_coords-player_coords == Vector2(1, -1)) or king_coords-player_coords == Vector2(-1, -1):
				moves.append(king_coords)
		PIECES.KNIGHT:
			moves.append(player_coords + Vector2(2, 1))
			moves.append(player_coords + Vector2(1, 2))
			moves.append(player_coords + Vector2(-2, -1))
			moves.append(player_coords + Vector2(-1, -2))
			
			moves.append(player_coords + Vector2(-2, 1))
			moves.append(player_coords + Vector2(2, -1))
			moves.append(player_coords + Vector2(-1, 2))
			moves.append(player_coords + Vector2(1, -2))
		PIECES.BISHOP:
			var d
			for i in range(0, 8):
				d = player_coords[0]-i
				if not (d == -d):
					moves.append(player_coords + Vector2(-d, d))
					moves.append(player_coords + Vector2(-d, -d))
		PIECES.ROOK:
			for i in range(0, 8):
				if not (i == player_coords[1]):
					moves.append(Vector2(player_coords[0], i))
				if not (i == player_coords[0]):
					moves.append(Vector2(i, player_coords[1]))
		PIECES.QUEEN:
			var d
			for i in range(0, 8):
				if not (i == player_coords[1]):
					moves.append(Vector2(player_coords[0], i))
				if not (i == player_coords[0]):
					moves.append(Vector2(i, player_coords[1]))
				d = player_coords[0]-i
				if not (d == -d):
					moves.append(player_coords + Vector2(-d, d))
					moves.append(player_coords + Vector2(-d, -d))
		PIECES.KING:
			moves.append(player_coords + Vector2(0, 1))
			moves.append(player_coords + Vector2(1, 0))
			moves.append(player_coords + Vector2(1, 1))
			moves.append(player_coords + Vector2(0, -1))
			moves.append(player_coords + Vector2(-1, 0))
			moves.append(player_coords + Vector2(-1, -1))
			moves.append(player_coords + Vector2(1, -1))
			moves.append(player_coords + Vector2(-1, 1))
	var i = 0
	while i < moves.size():
		if (moves[i][0] > 7) or (moves[i][0] < 0):
			moves.erase(moves[i])
			i -= 1
		elif (moves[i][1] > 7) or (moves[i][1] < 0):
			moves.erase(moves[i])
			i -= 1
		i += 1
	if moves.size() == 0:
		emit_signal("defeat")
		yield(get_tree().create_timer(3.0), "timeout")
		restart()
	else:
		valid_moves = moves
	return

func make_move_indicators():
	move_indicators = []
	for move in valid_moves:
		move_indicators.append(Sprite.new())
		add_child(move_indicators[-1])
		move_indicators[-1].texture = dot_texture
		move_indicators[-1].position = cell_size*move + (cell_size/2)*Vector2(1, 1)

func restart():
	delete_move_indicators()
	for i in queue_piece_sprites:
		i.queue_free()
	turn = 0
	initialise_queue_piece_sprites()
	player_coords = initial_player_coords
	initialise_sprites()
	get_valid_moves(piece_queue[turn])
	make_move_indicators()

func delete_move_indicators():
	for move in move_indicators:
		if move:
			move.queue_free()

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				
				var click_position = event.position - get_position()
				var clicked_cell_coords = Vector2(floor(click_position[0]/cell_size), floor(click_position[1]/cell_size))
				
				if clicked_cell_coords in valid_moves:
					
					player_coords = clicked_cell_coords
					player_sprite.position = cell_size*(clicked_cell_coords + Vector2(0.5, 0.5))
					$Tap.play()
					delete_move_indicators()
					if player_coords == king_coords:
						king_sprite.queue_free()
						game_manager.level_complete()
						emit_signal("victory")
						yield(get_tree().create_timer(3.0), "timeout")
						game_manager.go_to_level_select()
					elif turn == piece_queue.size()-1:
						emit_signal("defeat")
						yield(get_tree().create_timer(3.0), "timeout")
						restart()
					else:
						
						turn += 1
						get_valid_moves(piece_queue[turn])
						make_move_indicators()
						player_sprite.set_texture(piece_texture_map[piece_queue[turn]])
						queue_piece_sprites[turn-1].hide()
						for i in range(turn, piece_queue.size()):
							queue_piece_sprites[i].position = queue_piece_sprites[i].position + Vector2(0, 21)
						
				else:
					emit_signal("invalid_move")
	pass
