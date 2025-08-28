extends Node2D

var color: String
var colors: Array = ['blue', 'green', 'purple', 'red', 'yellow']

func _init() -> void:
	pass

func _ready() -> void:
	set_color(colors[randi() % colors.size()])

func get_color() -> String:
	return color

func set_color(c: String) -> void:
	color = c
	var tex = load("res://assets/png/diamonds/element_%s_diamond_glossy.png" % c)
	$Sprite2D.set_texture(tex)
