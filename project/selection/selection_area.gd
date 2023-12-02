class_name SelectionArea
extends Node2D

var anchor_point := Vector2.ZERO : set = _set_anchor_point
var _rect_corner := Vector2.ZERO
var _selection_color := Color(Color.DODGER_BLUE, 0.5)


func _process(_delta:float)->void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_update_selected_area()
	else:
		_release_selection()


func _update_selected_area()->void:
	_rect_corner = get_global_mouse_position()
	queue_redraw()


func _release_selection()->void:
	var selectable_nodes := get_tree().get_nodes_in_group("Selectable")
	var selected_area_polygon := _get_selected_area_polygon()
	for node in selectable_nodes:
		if Geometry2D.is_point_in_polygon(node.global_position, selected_area_polygon):
			node.selected = true
	queue_free()


func _get_selected_area_polygon()->PackedVector2Array:
	var selected_rect := _get_selected_rect()
	var polygon_verticies : PackedVector2Array = [
		selected_rect.position,
		Vector2(selected_rect.position.x + selected_rect.size.x, selected_rect.position.y),
		selected_rect.position + selected_rect.size,
		Vector2(selected_rect.position.x, selected_rect.position.y + selected_rect.size.y)
	]
	return polygon_verticies


func _get_selected_rect()->Rect2:
	var top_left_corner := Vector2.ZERO
	var bottom_right_corner := Vector2.ZERO
	
	top_left_corner.x = anchor_point.x if anchor_point.x < _rect_corner.x else _rect_corner.x
	top_left_corner.y = anchor_point.y if anchor_point.y < _rect_corner.y else _rect_corner.y
	
	bottom_right_corner.x = anchor_point.x if anchor_point.x > _rect_corner.x else _rect_corner.x
	bottom_right_corner.y = anchor_point.y if anchor_point.y > _rect_corner.y else _rect_corner.y
	
	return Rect2(top_left_corner, bottom_right_corner - top_left_corner)


func _set_anchor_point(value:Vector2)->void:
	anchor_point = value
	_rect_corner = value


func _draw()->void:
	draw_rect(_get_selected_rect(), _selection_color)
