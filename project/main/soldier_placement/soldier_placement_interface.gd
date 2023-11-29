extends Control

signal soldier_instance_requested(soldier)
signal battle_started

const SOLDIER_CONFIG_FOLDER_PATH := "res://soldier/soldier_configs/"

var _selected_soldier_config : SoldierConfig
var _is_mouse_in_legal_placement_area := false
var _soldiers_placed : Array = []
var _battle_started := false

@onready var _placement_button_container : HBoxContainer = $ScrollContainer/PlacementButtonContainer


func _ready()->void:
	update_placement_buttons()


func _input(event:InputEvent)->void:
	if event is InputEventMouseButton:
		if event.pressed:
			match event.button_index:
				MOUSE_BUTTON_LEFT:
					if _is_mouse_in_legal_placement_area:
						_add_soldier_at_mouse()
				MOUSE_BUTTON_RIGHT:
					_clear_soldier_config_selection()


func _add_soldier_at_mouse()->void:
	if _selected_soldier_config:
		var soldier := preload("res://soldier/soldier.tscn").instantiate()
		soldier.config = _selected_soldier_config
		soldier.position = get_global_mouse_position()
		soldier_instance_requested.emit(soldier)
		
		_soldiers_placed.append(
			{"config":_selected_soldier_config, "position":get_global_mouse_position()}
		)


func _clear_soldier_config_selection()->void:
	_selected_soldier_config = null


func update_placement_buttons()->void:
	_remove_all_placement_buttons()
	_add_new_placement_buttons()


func _remove_all_placement_buttons()->void:
	for button in _placement_button_container.get_children():
		button.queue_free()


func _add_new_placement_buttons()->void:
	var soldier_configs := _get_soldier_configs()
	for config in soldier_configs:
		_add_placement_button(config)


func _get_soldier_configs()->Array[SoldierConfig]:
	var soldier_config_files := DirAccess.get_files_at(SOLDIER_CONFIG_FOLDER_PATH)
	var soldier_config_instances : Array[SoldierConfig] = []
	for config_name in soldier_config_files:
		soldier_config_instances.append(
			load(SOLDIER_CONFIG_FOLDER_PATH + config_name)
		)
	return soldier_config_instances


func _add_placement_button(config:SoldierConfig)->void:
	var button := TextureButton.new()
	button.texture_normal = config.soldier_icon
	button.tooltip_text = config.soldier_name
	button.pressed.connect(_on_placement_button_pressed.bind(config))
	_placement_button_container.add_child(button)


func _on_placement_button_pressed(config:SoldierConfig)->void:
	_selected_soldier_config = config


func _on_start_battle_button_pressed()->void:
	battle_started.emit()


func _on_legal_placement_area_mouse_entered():
	_is_mouse_in_legal_placement_area = true


func _on_legal_placement_area_mouse_exited():
	_is_mouse_in_legal_placement_area = false
