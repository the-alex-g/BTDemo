class_name SelectionActions
extends Node

signal make_formation(members)

const ACTIONS := ["Delete", "Make Formation"]

@export var _selection_manager : SelectionManager


func _input(event:InputEvent)->void:
	if event is InputEventKey and event.is_pressed():
		match event.keycode:
			KEY_F:
				_make_formation_from_selected()
			KEY_DELETE:
				_delete_selected_nodes()
		_selection_manager.clear_selection()


func _make_formation_from_selected()->void:
	var formation_nodes := _selection_manager.get_selected_nodes(func(node): return node is Soldier and not node.is_in_formation)
	if formation_nodes.size() > 1:
		make_formation.emit(formation_nodes)


func _delete_selected_nodes()->void:
	for node in _selection_manager.get_selected_nodes():
		node.queue_free()
