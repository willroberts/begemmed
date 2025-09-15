# GdUnit generated TestSuite
class_name GridTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://grid.gd'
var Grid = preload('res://grid.tscn')

func test_id_to_coords() -> void:
	var grid = Grid.instantiate()
	var id = 25
	var expected = Vector2(1, 3)
	assert_vector(grid.id_to_coords(id)).is_equal(expected)

func test_coords_to_id() -> void:
	var grid = Grid.instantiate()
	var coords = Vector2(1, 3)
	var expected = 25
	assert_int(grid.coords_to_id(coords)).is_equal(expected)
