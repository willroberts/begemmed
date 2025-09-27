extends Node2D

var color: String
var colors: Dictionary = {
	'blue': preload("res://assets/png/diamonds/element_blue_diamond_glossy.png"),
	'green': preload("res://assets/png/diamonds/element_green_diamond_glossy.png"),
	'purple': preload("res://assets/png/diamonds/element_purple_diamond_glossy.png"),
	'red': preload("res://assets/png/diamonds/element_red_diamond_glossy.png"),
	'yellow': preload("res://assets/png/diamonds/element_yellow_diamond_glossy.png"),
}

func _ready() -> void:
	set_color(colors.keys()[randi() % colors.size()])

func get_color() -> String:
	return color

func set_color(c: String) -> void:
	if c not in colors:
		push_error('invalid color: %s' % c)
		c = 'blue'
	color = c
	$Sprite2D.set_texture(colors[c])

func set_label(value: int) -> void:
	$Label.text = str(value)

func set_highlight(v: bool) -> void:
	$Highlight.visible = v
