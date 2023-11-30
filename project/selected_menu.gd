class_name SelectionMenuManager
extends Control

signal make_formation(members)

const ACTIONS := ["Delete", "Make Formation"]


func _input(event:InputEvent)->void:
	if event is InputEventKey:
		match event.keycode:
			KEY_F:
				_make_formation_from_selected()


func _make_formation_from_selected()->void:
	var formation_nodes := _get_selected_nodes(func(node): return node is Soldier and not node.is_in_formation)
	if formation_nodes.size() > 1:
		make_formation.emit(formation_nodes)


func _get_selected_nodes(filter := func(_node): return true)->Array[Node]:
	var selected_nodes : Array[Node] = []
	var selectable_nodes := get_tree().get_nodes_in_group("Selectable")
	for node in selectable_nodes:
		if node.selected and filter.call(node):
			selected_nodes.append(node)
	return selected_nodes
