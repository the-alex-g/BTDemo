class_name Soldier
extends CharacterBody2D

const DISTANCE_BUFFER := 1.0
const GLOBAL_BLACKBOARD_NAME := "global"

@export var config := SoldierConfig.new() : set = set_config
@export var team_index := 0

var stats : SoldierStats
var target_location : Vector2
var unit_index := -1

@onready var _behavior_tree : BeehaveTree = $BeehaveTree


func _physics_process(delta:float)->void:
	if _can_move() and not _is_at_target():
		_move_towards_target_location(delta)


func _can_move()->bool:
	if target_location == null:
		return false
	return true


func _is_at_target()->bool:
	if target_location.distance_squared_to(global_position) < pow(DISTANCE_BUFFER, 2.0):
		return true
	return false


func _move_towards_target_location(delta:float)->void:
	var angle := get_angle_to(target_location)
	var motion := Vector2.RIGHT.rotated(angle) * delta * stats.speed
	move_and_collide(motion)


func set_config(new_config:SoldierConfig)->void:
	stats = new_config.soldier_stats


func set_behavior_tree_blackboard(blackboard:Blackboard)->void:
	_behavior_tree.blackboard = blackboard
	unit_index = blackboard.get_value("units", [], GLOBAL_BLACKBOARD_NAME).size()
	
	var unit_array : Array = blackboard.get_value("units", [], GLOBAL_BLACKBOARD_NAME)
	unit_array.append(unit_index)
	
	blackboard.set_value(
		"units",
		unit_array,
		GLOBAL_BLACKBOARD_NAME
	)
	blackboard.set_value("actor", self, str(unit_index))


func remove_data_from_blackboard(blackboard:Blackboard)->void:
	pass
