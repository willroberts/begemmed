extends Node

@onready var GRID_SIZE: int = $Grid.GRID_SIZE
@onready var GEM_SIZE: int = $Grid.GEM_SIZE
@onready var score_label = $ScoreLabel

var score := 0
var selected_cell := Vector2i(-1, -1)
var processing_move := false

func _ready() -> void:
	''' Set the window background to blue on initialization.
	'''
	RenderingServer.set_default_clear_color(Color.STEEL_BLUE)

func _input(event: InputEvent) -> void:
	''' Handle mouse events, calling process_swap() when a move is confirmed.
	'''
	# Prevent inputs during processing.
	if processing_move: return

	# Ignore unsupported input.
	if event is not InputEventMouseButton: return
	if not event.pressed: return
	if event.button_index != MOUSE_BUTTON_LEFT: return

	# Capture and validate click.
	var click_pos: Vector2 = event.position
	var x = int(click_pos.x / GEM_SIZE)
	if x < 0 or x >= GRID_SIZE: return
	var y = int(click_pos.y / GEM_SIZE)
	if y < 0 or y >= GRID_SIZE: return
	var clicked_cell = Vector2i(x, y)

	# Clicking an already-selected cell does nothing.
	if clicked_cell == selected_cell:
		reset_selection()
		return

	# This is the first click; save the position and return.
	if selected_cell == Vector2i(-1, -1):
		selected_cell = clicked_cell
		$Grid.gem_nodes[selected_cell.y][selected_cell.x].set_highlight(true)
		return

	# This is the second click; validate and then swap gem positions.
	# Disallow swapping non-adjacent gems.
	if abs(clicked_cell.x - selected_cell.x) + abs(clicked_cell.y - selected_cell.y) != 1:
		reset_selection()
		return
	# Disallow swaps which would not result in a new match.
	if not $Grid.swap_would_result_in_match($Grid.gem_nodes, clicked_cell, selected_cell):
		print('Swap would not result in match.')
		reset_selection()
		return
	process_swap(clicked_cell, selected_cell)

func process_swap(clicked: Vector2i, selected: Vector2i) -> void:
	''' Lock input while processing matches and replacing gems. Increments score.
	'''
	processing_move = true
	score += await $Grid.swap_gems_and_explode_matches($Grid.gem_nodes, clicked, selected)
	$ScoreLabel.text = "Score: %d" % score
	reset_selection()
	processing_move = false

func reset_selection() -> void:
	''' When a gem is deselected or moved, disable highlighting.
	'''
	if selected_cell == Vector2i(-1, -1): return
	if $Grid.gem_nodes[selected_cell.y][selected_cell.x]:
		$Grid.gem_nodes[selected_cell.y][selected_cell.x].set_highlight(false)
	selected_cell = Vector2i(-1, -1)
