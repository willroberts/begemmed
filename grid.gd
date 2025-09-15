extends Node2D

var Gem = preload("res://gem.tscn")

var grid_size: int = 8
var gem_size: int = 144 # pixels
var gems: Array = []

func _init() -> void:
	''' Initializes the grid by filling rows and columns with gems.
	If matches exist in the generated grid, randomize those cells
	until no matches exist.
	'''
	generate_grid()

func _ready() -> void:
	for m in find_horizontal_matches():
		print('HM: ', m)
	for m in find_vertical_matches():
		print('VM: ', m)

func _input(event: InputEvent) -> void:
	pass
	
func _process(delta: float) -> void:
	pass

func generate_grid() -> void:
	# Generate initial contents.
	for y in range(0, grid_size):
		for x in range(0, grid_size):
			var g = Gem.instantiate()
			g.position = Vector2(x*gem_size, y*gem_size)
			g.set_label(coords_to_id(Vector2(x, y)))
			gems.append(g)

	# Replace duplicates.
	#TBD

	# Render gems.
	for g in gems:
		add_child(g)

func find_horizontal_matches() -> Array:
	var matches = []
	for i in range(0, len(gems)-1):
		var matched = [i]
		for j in range(i, len(gems)-1):
			if not next_horizontal_node_matches(j):
				break
			matched.append(j+1)
		if len(matched) > 2: matches.append(matched)
	return matches

func find_vertical_matches() -> Array:
	var matches = []
	for i in range(0, len(gems)-1):
		var matched = [i]
		for j in range(i, len(gems)-1, grid_size):
			if not next_vertical_node_matches(j):
				break
			matched.append(j+grid_size)
		if len(matched) > 2: matches.append(matched)
	return matches

func next_horizontal_node_matches(id: int) -> bool:
	if id % grid_size == 7: return false
	if gems[id].get_color() != gems[id+1].get_color(): return false
	return true

func next_vertical_node_matches(id: int) -> bool:
	if id > len(gems) - 1 - grid_size: return false
	if gems[id].get_color() != gems[id+grid_size].get_color(): return false
	return true

func id_to_coords(id: int) -> Vector2:
	var x = id % grid_size
	var y = (id - x) / grid_size
	return Vector2(x, y)

func coords_to_id(coords: Vector2) -> int:
	return coords.y * grid_size + coords.x
