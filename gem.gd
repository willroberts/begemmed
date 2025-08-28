extends Node2D

var color: String
var colors: Array = ['blue', 'green', 'purple', 'red', 'yellow']
var textures: Dictionary = {
	'blue': preload("res://assets/png/diamonds/element_blue_diamond_glossy.png"),
	'green': preload("res://assets/png/diamonds/element_green_diamond_glossy.png"),
	'purple': preload("res://assets/png/diamonds/element_purple_diamond_glossy.png"),
	'red': preload("res://assets/png/diamonds/element_red_diamond_glossy.png"),
	'yellow': preload("res://assets/png/diamonds/element_yellow_diamond_glossy.png"),
}

func _ready() -> void:
	set_color(colors[randi() % colors.size()])

func get_color() -> String:
	return color

func set_color(c: String) -> void:
	if c not in textures:
		push_error('invalid color: %s' % c)
		c = 'blue'
	color = c
	$Sprite2D.set_texture(textures[c])
