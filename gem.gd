class_name Gem
extends Node2D

static var COLORS: Dictionary[String, Resource] = {
	'blue': preload("res://assets/png/diamonds/element_blue_diamond_glossy.png"),
	'green': preload("res://assets/png/diamonds/element_green_diamond_glossy.png"),
	'purple': preload("res://assets/png/diamonds/element_purple_diamond_glossy.png"),
	'red': preload("res://assets/png/diamonds/element_red_diamond_glossy.png"),
	'yellow': preload("res://assets/png/diamonds/element_yellow_diamond_glossy.png"),
}

var color: String

func _ready() -> void:
	set_color(random_color())

func get_color() -> String:
	return color

func set_color(c: String) -> void:
	if c not in COLORS:
		push_error('invalid color: %s' % c)
		c = 'blue'
	color = c
	$Sprite2D.set_texture(COLORS[c])

static func random_color() -> String:
	return COLORS.keys()[randi() % COLORS.size()]

func set_label(value: int) -> void:
	$Label.text = str(value)

func set_highlight(v: bool) -> void:
	$Highlight.visible = v
