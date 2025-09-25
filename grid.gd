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
	generate_grid()

func _ready() -> void:
	while true:
		var matches = find_horizontal_matches() + find_vertical_matches()
		if len(matches) == 0:
			print('no more matches found')
			break
		print('matches found; replacing')
		replace_matches(matches)

func generate_grid() -> void:
	for y in range(0, GRID_SIZE):
		var row = []
		for x in range(0, GRID_SIZE):
			var g = Gem.instantiate()
			g.position = Vector2(x*GEM_SIZE, y*GEM_SIZE)
			add_child(g)
			row.append(g)
		gems.append(row)

func find_horizontal_matches() -> Array:
	var matches = []
	for y in range(0, GRID_SIZE):
		var count := 1
		for x in range(0, GRID_SIZE):
			if gems[y][x].get_color() == gems[y][x-1].get_color():
				count += 1
			else:
				if count >= 3:
					for k in range(x - count, x):
						if k < 0: continue
						matches.append(Vector2i(k, y))
				count = 1
		if count >= 3:
			for k in range(GRID_SIZE - count, GRID_SIZE):
				if k < 0: continue
				matches.append(Vector2i(k, y))
	return matches

func find_vertical_matches() -> Array:
	var matches = []

	for x in range(GRID_SIZE):
		var count := 1
		for y in range(1, GRID_SIZE):
			if gems[y][x].get_color() == gems[y - 1][x].get_color():
				count += 1
			else:
				if count >= 3:
					for k in range(y - count, y):
						if k < 0: continue
						matches.append(Vector2i(x, k))
				count = 1
		if count >= 3:
			for k in range(GRID_SIZE - count, GRID_SIZE):
				if k < 0: continue
				matches.append(Vector2i(x, k))

	return matches

func replace_matches(matches: Array) -> void:
	for m in matches:
		var existing = gems[m.y][m.x]
		remove_child(existing)
		var g = Gem.instantiate()
		g.position = Vector2(m.x*GEM_SIZE, m.y*GEM_SIZE)
		gems[m.y][m.x] = g
		add_child(g)

func swap_gems(first: Vector2i, second: Vector2i) -> void:
	var first_color = gems[first.y][first.x].get_color()
	var second_color = gems[second.y][second.x].get_color()
	gems[first.y][first.x].set_color(second_color)
	gems[second.y][second.x].set_color(first_color)
