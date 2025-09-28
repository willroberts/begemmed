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
		var matches = find_matches(gem_nodes)
		if len(matches) == 0:
			print('no more matches found')
			break
		print('matches found; replacing')
		for m in matches:
			gem_nodes[m.y][m.x].set_color(Gem.random_color())

func find_matches(grid_contents: Array) -> Array:
	return find_horizontal_matches(grid_contents) + find_vertical_matches(grid_contents)

func find_horizontal_matches(grid_contents: Array) -> Array:
	var matches = []
	for y in range(0, GRID_SIZE):
		var count := 1
		# Avoid array bounds issues by starting from 1.
		for x in range(1, GRID_SIZE):
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
		# Avoid array bounds issues by starting from 1.
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

func swap_gems_and_explode_matches(grid_contents: Array, first: Vector2i, second: Vector2i) -> void:
	''' Swaps the position of two gems. Finds all resulting matches and deletes matching gems. Makes gems
	fall to fill empty spaces, generating new gems as needed.
	'''
	swap_nodes(grid_contents, first, second)
	grid_contents[first.y][first.x].set_highlight(false)
	grid_contents[second.y][second.x].set_highlight(false)
	var matches = find_matches(gem_nodes)

func swap_would_result_in_match(grid_contents: Array, first: Vector2i, second: Vector2i) -> bool:
	var copy = deep_copy_colors(grid_contents)
	var tmp = copy[first.y][first.x]
	copy[first.y][first.x] = copy[second.y][second.x]
	copy[second.y][second.x] = tmp
	return len(find_color_matches(copy)) > 0

func find_color_matches(grid_contents: Array) -> Array:
	var matches = []

	# Horizontal matches
	for y in range(GRID_SIZE):
		var count := 1
		for x in range(1, GRID_SIZE):
			if grid_contents[y][x] == grid_contents[y][x-1]:
				count += 1
				continue
			if count >= 3:
				for k in range(x - count, x):
					matches.append(Vector2i(k, y))
			count = 1
		if count >= 3:
			for k in range(GRID_SIZE - count, GRID_SIZE):
				matches.append(Vector2i(k, y))

	# Vertical matches
	for x in range(GRID_SIZE):
		var count := 1
		for y in range(1, GRID_SIZE):
			if grid_contents[y][x] == grid_contents[y-1][x]:
				count += 1
				continue
			if count >= 3:
				for k in range(y - count, y):
					matches.append(Vector2i(x, k))
			count = 1
		if count >= 3:
			for k in range(GRID_SIZE - count, GRID_SIZE):
				matches.append(Vector2i(x, k))

	return matches

func swap_nodes(grid_contents: Array, first: Vector2i, second: Vector2i) -> void:
	var tmp = grid_contents[first.y][first.x]
	grid_contents[first.y][first.x] = grid_contents[second.y][second.x]
	grid_contents[second.y][second.x] = tmp
	grid_contents[first.y][first.x].position = Vector2(first.x*GEM_SIZE, first.y*GEM_SIZE)
	grid_contents[second.y][second.x].position = Vector2(second.x*GEM_SIZE, second.y*GEM_SIZE)

func deep_copy_colors(grid_contents: Array) -> Array:
	''' Since Array.duplicate(true) deep copies references of contained objects, it is not
	suitable for validating swaps without performing them. Instead, only copy color values.
	'''
	var result = []
	for y in range(0, GRID_SIZE):
		var row = []
		for x in range(0, GRID_SIZE):
			row.append(grid_contents[y][x].get_color())
		result.append(row)
	return result
