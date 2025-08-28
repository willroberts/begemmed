extends Node2D

var Gem = preload("res://gem.tscn")

var width: int = 5 # columns
var height: int = 5 # rows
var gem_size: int = 48 # pixels

func _init() -> void:
	var gems: Array = []
	for y in range(0, height):
		for x in range(0, width):
			var g = Gem.instantiate()
			g.position = Vector2(x*48, y*48)
			add_child(g)
			gems.append(g)

func _ready() -> void:
	draw()
	
func draw() -> void:
	pass

func _input(event: InputEvent) -> void:
	pass
	
func _process(delta: float) -> void:
	pass
