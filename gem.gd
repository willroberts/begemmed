extends Node2D

var color: String
var colors: Array = ['blue', 'green', 'grey', 'purple', 'red', 'yellow']

func _init() -> void:
	color = colors[randi() % colors.size()]

func _ready() -> void:
	var tex = load("res://assets/png/diamonds/element_%s_diamond_glossy.png" % color)
	$Sprite2D.set_texture(tex)

func get_color() -> String:
	return color

func set_color(c: String) -> void:
	color = c
