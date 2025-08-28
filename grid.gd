extends Node2D

var Gem = preload("res://gem.tscn")

var width: int = 5 # columns
var height: int = 5 # rows
var gem_size: int = 192 # pixels
var gems: Array = []

func _init() -> void:
	for y in range(0, height):
		for x in range(0, width):
			var g = Gem.instantiate()
			g.position = Vector2(x*gem_size, y*gem_size)
			add_child(g)
			gems.append(g)

func _ready() -> void:
	find_matches()

func same_color(id1: int, id2: int) -> bool:
	return gems[id1].get_color() == gems[id2].get_color()
	
func find_matches() -> void:
	for y in range(0, height):
		for x in range(0, width):
			var id = y*5 + x
			# check for horizontal matches
			if x < width-2 && same_color(id, id+1) && same_color(id+1, id+2):
				print('Horizontal match found!')
			# check for vertical matches
			if y < width-2 && same_color(id, id+width) && same_color(id+width, id+(width*2)):
				print('Vertical match found!')

func _input(event: InputEvent) -> void:
	pass
	
func _process(delta: float) -> void:
	pass
