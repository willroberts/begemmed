# GdUnit generated TestSuite
class_name GridTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://grid.gd'
var Grid = preload('res://grid.tscn')

func test_assert() -> void:
	assert_vector(Vector2(0, 0)).is_equal(Vector2(0, 0))
