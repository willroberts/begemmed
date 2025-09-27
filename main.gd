extends Node

@onready var GRID_SIZE: int = $Grid.GRID_SIZE
@onready var GEM_SIZE: int = $Grid.GEM_SIZE

var score := 0
var selected_cell := Vector2i(-1, -1)

'''
TODO:
1. Only allow moves if they would result in a match.
2. Detect matches after a valid move.
3. Delete the matches and make gems "fall" into place.
4. Add the number of deleted gems to the score.
5. Display the score on the screen.
6. Add animations.
'''

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.STEEL_BLUE)

func _input(event: InputEvent) -> void:
	# Ignore unsupported input.
	if event is not InputEventMouseButton:
		return
	if not event.pressed:
		return
	if event.button_index != MOUSE_BUTTON_LEFT:
		return

	# Capture and validate click.
	var click_pos: Vector2 = event.position
	var x = int(click_pos.x / GEM_SIZE)
	if x < 0 or x >= GRID_SIZE: return
	var y = int(click_pos.y / GEM_SIZE)
	if y < 0 or y >= GRID_SIZE: return
	var clicked_cell = Vector2i(x, y)

	# Clicking an already-selected cell does nothing.
	if clicked_cell == selected_cell:
		return

	# This is the first click; save the position and return.
	if selected_cell == Vector2i(-1, -1):
		selected_cell = clicked_cell
		#$Grid.gem_nodes[selected_cell.y][selected_cell.x].set_highlight(true)
		return

	# This is the second click; swap gem positions.
	# Disallow swapping non-adjacent gems.
	if abs(clicked_cell.x - selected_cell.x) + abs(clicked_cell.y - selected_cell.y) != 1:
		return
	# Disallow swaps which would not result in a new match.
	if $Grid.swap_would_result_in_match($Grid.gem_nodes, clicked_cell, selected_cell):
		print('Swap would result in match.')
		$Grid.swap_gems_and_explode_matches($Grid.gem_nodes, clicked_cell, selected_cell)
	else:
		print('Swap would not result in match.')
	reset_selection()

func reset_selection():
	$Grid.gem_nodes[selected_cell.y][selected_cell.x].set_highlight(false)
	selected_cell = Vector2i(-1, -1)
