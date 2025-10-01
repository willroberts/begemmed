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
			if grid_contents[y][x] == null or grid_contents[y][x-1] == null:
				continue
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
			if grid_contents[y][x] == null or grid_contents[y-1][x] == null:
				continue
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

func swap_gems_and_explode_matches(grid_contents: Array, first: Vector2i, second: Vector2i) -> int:
	''' Swaps the position of two gems. Finds all resulting matches and deletes matching gems. Makes gems
	fall to fill empty spaces, generating new gems as needed.
	'''
	#if not grid_contents[first.y][first.x] or not grid_contents[second.y][second.x]:
	#	print('attempted to swap null references; bailing')
	#	return
	swap_nodes(grid_contents, first, second)
	grid_contents[first.y][first.x].set_highlight(false)
	grid_contents[second.y][second.x].set_highlight(false)

	# Process until no further matches exist:
	var total_deleted: int = 0
	while true:
		var matches = find_matches(grid_contents)
		if len(matches) == 0: break
		total_deleted += len(matches)
		await animate_gem_destruction(grid_contents, matches)
		apply_gravity(grid_contents)
		fill_empty_spaces(grid_contents)
		await get_tree().create_timer(0.3).timeout

	return total_deleted

func animate_gem_destruction(grid_contents: Array, matches: Array) -> void:
	''' Animates gems being destroyed by applying an upward impulse and simulating gravity.
	'''
	var animation_duration = 0.5  # Seconds.
	var initial_velocity = -400.0
	var gravity = 1200.0
	var animating_gems = []

	for m in matches:
		if grid_contents[m.y][m.x]:
			var gem = grid_contents[m.y][m.x]
			animating_gems.append({
				"gem": gem,
				"start_pos": gem.position,
				"velocity": initial_velocity,
				"time": 0.0
			})
			grid_contents[m.y][m.x] = null

	var elapsed = 0.0
	const DELTA_TIME = 0.016  # Targeting 60 FPS
	while elapsed < animation_duration:
		for gem_data in animating_gems:
			gem_data["time"] += DELTA_TIME
			gem_data["velocity"] += gravity * DELTA_TIME
			var new_y = gem_data["gem"].position.y + gem_data["velocity"] * DELTA_TIME
			gem_data["gem"].position.y = new_y
			gem_data["gem"].modulate.a = 1.0 - (elapsed / animation_duration) # Fade out. # Fade out
		elapsed += DELTA_TIME
		await get_tree().create_timer(DELTA_TIME).timeout
	for gem_data in animating_gems:
		gem_data["gem"].queue_free()

func apply_gravity(grid_contents: Array) -> void:
	''' Make existing gems fall when empty space exists beneath them.
	'''
	for x in range(0, GRID_SIZE):
		var pos = GRID_SIZE - 1
		for y in range(GRID_SIZE-1, -1, -1):
			if grid_contents[y][x] != null:
				if y != pos:
					# Move the gem down a space.
					grid_contents[pos][x] = grid_contents[y][x]
					grid_contents[y][x] = null
					grid_contents[pos][x].position = Vector2(x*GEM_SIZE, pos*GEM_SIZE)
				pos -= 1

func fill_empty_spaces(grid_contents: Array) -> void:
	''' Generate new gems to fill any resulting gaps after explosions.
	'''
	for y in range(0, GRID_SIZE):
		for x in range(0, GRID_SIZE):
			if grid_contents[y][x] == null:
				var g = GemClass.instantiate()
				g.position = Vector2(x*GEM_SIZE, y*GEM_SIZE)
				add_child(g)
				grid_contents[y][x] = g

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
			if grid_contents[y][x]:
				row.append(grid_contents[y][x].get_color())
			else:
				row.append('')
		result.append(row)
	return result
