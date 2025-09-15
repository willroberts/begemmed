extends Node2D

var Gem = preload("res://gem.tscn")

var width: int = 8 # columns
var height: int = 8 # rows
var gem_size: int = 144 # pixels
var gems: Array = []

func _init() -> void:
	''' Initializes the grid by filling rows and columns with gems.
	If matches exist in the generated grid, randomize those cells
	until no matches exist.
	'''
	generate_grid()

func _ready() -> void:
	find_matches()

func _input(event: InputEvent) -> void:
	pass
	
func _process(delta: float) -> void:
	pass

func generate_grid() -> void:
	# Generate initial contents.
	for y in range(0, height):
		for x in range(0, width):
			var g = Gem.instantiate()
			g.position = Vector2(x*gem_size, y*gem_size)
			add_child(g)
			gems.append(g)
	# Replace duplicates.
	#while true:
	#	var matches = find_matches()
	#	if len(matches) == 0: break
	#	for i in matches:
	#		var g = Gem.instantiate()
	#		g.position = id_to_coords(i)
	#		add_child(g)
	#		gems[i] = g
	#	break

func same_color(id1: int, id2: int) -> bool:
	return gems[id1].get_color() == gems[id2].get_color()
	
func find_matches() -> Array[int]:
	var matches: Array[int] = []
	for y in range(0, height):
		for x in range(0, width):
			var id = y*5 + x
			# check for horizontal matches
			if x < width-2 && same_color(id, id+1) && same_color(id+1, id+2):
				if id not in matches: matches.append(id)
				if id+1 not in matches: matches.append(id+1)
				print('Horizontal match found!')
			# check for vertical matches
			if y < width-2 && same_color(id, id+width) && same_color(id+width, id+(width*2)):
				if id not in matches: matches.append(id)
				if id+width not in matches: matches.append(id+width)
				print('Vertical match found!')
	return matches

func id_to_coords(id: int) -> Vector2:
	var x = id % width
	var y = (id - x) / width
	return Vector2(x, y)

func coords_to_id(coords: Vector2) -> int:
	return coords.y * width + coords.x
