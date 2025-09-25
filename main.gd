extends Node

@onready var GRID_SIZE: int = $Grid.GRID_SIZE
@onready var GEM_SIZE: int = $Grid.GEM_SIZE

var score := 0
var selected_cell := Vector2i(-1, -1)

func _init() -> void:
	pass

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

	# Capture click.
	var click_pos: Vector2 = event.position
	var x = int(click_pos.x / GEM_SIZE)
	var y = int(click_pos.y / GEM_SIZE)

	# Validate click.
	if x < 0 or x >= GRID_SIZE: return
	if y < 0 or y >= GRID_SIZE: return

	# This is the first click; save the position and return.
	var clicked_cell = Vector2i(x, y)
	if selected_cell == Vector2i(-1, -1):
		selected_cell = clicked_cell
		return

	# Disallow swapping non-adjacent gems.
	if abs(clicked_cell.x - selected_cell.x) + abs(clicked_cell.y - selected_cell.y) != 1:
		return

	# This is the second click; swap gem positions.
	$Grid.swap_gems(clicked_cell, selected_cell)
	# TODO: Check for matches.
	selected_cell = Vector2i(-1, -1)
	
func _process(delta: float) -> void:
	pass
