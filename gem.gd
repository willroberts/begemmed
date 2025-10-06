class_name Gem
extends Node2D

static var COLORS: Dictionary[String, Resource] = {
	'blue': preload("res://assets/png/diamonds/element_blue_diamond_glossy.png"),
	'green': preload("res://assets/png/diamonds/element_green_diamond_glossy.png"),
	'purple': preload("res://assets/png/diamonds/element_purple_diamond_glossy.png"),
	'red': preload("res://assets/png/diamonds/element_red_diamond_glossy.png"),
	'yellow': preload("res://assets/png/diamonds/element_yellow_diamond_glossy.png"),
}

var color: String # The color of this gem.

static func random_color() -> String:
	''' Returns the name of a random color from the COLORS dict.
	'''
	return COLORS.keys()[randi() % COLORS.size()]

func _ready() -> void:
	''' On initialization, choose a random color.
	'''
	set_color(random_color())

func get_color() -> String:
	''' Return this gem's color.
	'''
	return color

func set_color(c: String) -> void:
	''' Set this gem's color, defaulting to blue if an invalid color is provided.
	'''
	if c not in COLORS:
		push_error('invalid color: %s' % c)
		c = 'blue'
	color = c
	$Sprite2D.set_texture(COLORS[c])

func set_highlight(v: bool) -> void:
	''' Marks the highlight ring for this gem as visible. Used to indicate selection.
	'''
	$Highlight.visible = v
