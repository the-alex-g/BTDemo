class_name SelectionManager
extends Node2D


func _input(event:InputEvent)->void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			match event.button_index:
				MOUSE_BUTTON_LEFT:
					_start_selection_at_mouse()
				MOUSE_BUTTON_RIGHT:
					clear_selection()


func _start_selection_at_mouse()->void:
	var selection := SelectionArea.new()
	selection.anchor_point = get_global_mouse_position()
	add_child(selection)


func clear_selection()->void:
	for selected_node in get_selected_nodes():
		selected_node.selected = false


func get_selected_nodes(filter := func(_node): return true)->Array[Node]:
	var selected_nodes : Array[Node] = []
	var selectable_nodes := get_tree().get_nodes_in_group("Selectable")
	for node in selectable_nodes:
		if node.selected and filter.call(node):
			selected_nodes.append(node)
	return selected_nodes
