extends Node2D

var GemClass = preload("res://gem.tscn")

var GRID_SIZE: int = 8
var GEM_SIZE: int = 144 # pixels
var gem_nodes: Array = [] # [][]Gem

func _init() -> void:
	''' Initializes the grid by filling rows and columns with gems.
	'''
	for y in range(0, GRID_SIZE):
		var row: Array[Gem] = []
		for x in range(0, GRID_SIZE):
			var g = GemClass.instantiate()
			g.position = Vector2(x*GEM_SIZE, y*GEM_SIZE)
			add_child(g)
			row.append(g)
		gem_nodes.append(row)

func _ready() -> void:
	''' If matches exist in the generated grid, randomize until no matches exist.
	'''
	while true:
		var matches = find_horizontal_matches(gem_nodes) + find_vertical_matches(gem_nodes)
		if len(matches) == 0:
			print('no more matches found')
			break
		print('matches found; replacing')
		for m in matches:
			gem_nodes[m.y][m.x].set_color(Gem.random_color())

func find_horizontal_matches(grid_contents: Array) -> Array:
	var matches = []
	for y in range(0, GRID_SIZE):
		var count := 1
		for x in range(0, GRID_SIZE):
			if grid_contents[y][x].get_color() == grid_contents[y][x-1].get_color():
				count += 1
				continue
			if count >= 3:
				for k in range(x - count, x):
					if k >= 0: matches.append(Vector2i(k, y))
			count = 1
		if count >= 3:
			for k in range(GRID_SIZE - count, GRID_SIZE):
				if k >= 0: matches.append(Vector2i(k, y))
	return matches

func find_vertical_matches(grid_contents: Array) -> Array:
	var matches = []
	for x in range(0, GRID_SIZE):
		var count := 1
		for y in range(1, GRID_SIZE):
			if grid_contents[y][x].get_color() == grid_contents[y-1][x].get_color():
				count += 1
				continue
			if count >= 3:
				for k in range(y - count, y):
					if k >= 0: matches.append(Vector2i(x, k))
			count = 1
		if count >= 3:
			for k in range(GRID_SIZE - count, GRID_SIZE):
				if k >= 0: matches.append(Vector2i(x, k))
	return matches
'''
func swap_gems(grid_contents: Array, first: Vector2i, second: Vector2i) -> void:
	grid_contents[first.y][first.x] = grid_contents[second.y][second.x]
	# TODO: Check for matches here.

func swap_would_result_in_match(grid_contents: Array, first: Vector2i, second: Vector2i) -> bool:
	var colors = extract_colors(grid_contents)
	swap_gems(colors, first, second)
	return len(find_horizontal_matches(colors) + find_vertical_matches(colors)) > 0

func extract_colors(grid_contents: Array) -> Array:
	var colors = []
	for y in range(0, GRID_SIZE):
		var color_row = []
		for x in range(0, GRID_SIZE):
			color_row.append(grid_contents[y][x].get_color())
		colors.append(color_row)
	return colors
'''
