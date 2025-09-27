extends Node2D

var Gem = preload("res://gem.tscn")

var GRID_SIZE: int = 8
var GEM_SIZE: int = 144 # pixels
var gems: Array = [] # [][]Gem

func _init() -> void:
	''' Initializes the grid by filling rows and columns with gems.
	If matches exist in the generated grid, randomize those cells
	until no matches exist.
	'''
	for y in range(0, GRID_SIZE):
		var row = []
		for x in range(0, GRID_SIZE):
			var g = Gem.instantiate()
			g.position = Vector2(x*GEM_SIZE, y*GEM_SIZE)
			add_child(g)
			row.append(g)
		gems.append(row)

func _ready() -> void:
	while true:
		var matches = find_horizontal_matches(gems) + find_vertical_matches(gems)
		if len(matches) == 0:
			print('no more matches found')
			break
		print('matches found; replacing')
		for m in matches:
			var existing = gems[m.y][m.x]
			remove_child(existing)
			var g = Gem.instantiate()
			g.position = Vector2(m.x*GEM_SIZE, m.y*GEM_SIZE)
			gems[m.y][m.x] = g
			add_child(g)

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
	for x in range(GRID_SIZE):
		var count := 1
		for y in range(1, GRID_SIZE):
			if grid_contents[y][x].get_color() == grid_contents[y - 1][x].get_color():
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

func swap_gems(grid_contents: Array, first: Vector2i, second: Vector2i) -> void:
	var first_color = grid_contents[first.y][first.x].get_color()
	var second_color = grid_contents[second.y][second.x].get_color()
	grid_contents[first.y][first.x].set_color(second_color)
	grid_contents[second.y][second.x].set_color(first_color)
	# TODO: Check for matches here.

func swap_would_result_in_match(grid_contents: Array, first: Vector2i, second: Vector2i) -> bool:
	# FIXME: Deep copy results in additional child objects in the scene.
	var result = grid_contents.duplicate(true)
	swap_gems(result, first, second)
	var matches = find_horizontal_matches(result) + find_vertical_matches(result)
	return len(matches) > 0
