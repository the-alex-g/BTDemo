class_name Soldier
extends CharacterBody2D

const DISTANCE_BUFFER := 1.0
const GLOBAL_BLACKBOARD_NAME := "global"
const ATTACK_COOLDOWN_VARIANCE_PERCENTAGE := 0.25

@export var config := SoldierConfig.new() : set = set_config
@export var team_index := 0

var stats : SoldierStats
var target_location : Vector2
var unit_index := -1
var can_attack := true

@onready var _behavior_tree : BeehaveTree = $BeehaveTree
@onready var _attack_cooldown_timer : Timer = $AttackCooldownTimer


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


func generate_attack()->Attack:
	var attack := Attack.new()
	attack.damage = stats.damage
	can_attack = false
	_attack_cooldown_timer.start(_get_attack_cooldown_time())
	return attack


func _get_attack_cooldown_time()->float:
	var cooldown_time := config.attack_cooldown_time
	return cooldown_time + randf_range(-cooldown_time, cooldown_time) * ATTACK_COOLDOWN_VARIANCE_PERCENTAGE


func hit_with_attack(attack:Attack)->void:
	stats.health -= attack.damage
	if stats.health <= 0:
		_remove_data_from_blackboard(_behavior_tree.blackboard)
		queue_free()


func _remove_data_from_blackboard(blackboard:Blackboard)->void:
	_erase_item_from_blackboard_array("units", unit_index, blackboard)
	_erase_item_from_blackboard_array("actor_list", self, blackboard)


func _erase_item_from_blackboard_array(array_name:String, item:Variant, blackboard:Blackboard)->void:
	var stored : Array = blackboard.get_value(array_name, [], GLOBAL_BLACKBOARD_NAME)
	stored.erase(item)
	blackboard.set_value(array_name, stored, GLOBAL_BLACKBOARD_NAME)


func set_config(new_config:SoldierConfig)->void:
	stats = new_config.soldier_stats


func set_behavior_tree_blackboard(blackboard:Blackboard)->void:
	_behavior_tree.blackboard = blackboard
	unit_index = blackboard.get_value("unit_counter", 0, GLOBAL_BLACKBOARD_NAME)
	
	_increment_blackboard_int("unit_counter", blackboard)
	_append_item_to_blackboard_array("units", unit_index, blackboard)
	_append_item_to_blackboard_array("actor_list", self, blackboard)


func _increment_blackboard_int(field_name:String, blackboard:Blackboard)->void:
	blackboard.set_value(
		field_name,
		blackboard.get_value(field_name, 0, GLOBAL_BLACKBOARD_NAME) + 1,
		GLOBAL_BLACKBOARD_NAME
	)


func _append_item_to_blackboard_array(array_name:String, item:Variant, blackboard:Blackboard)->void:
	var stored : Array = blackboard.get_value(array_name, [], GLOBAL_BLACKBOARD_NAME)
	stored.append(item)
	blackboard.set_value(array_name, stored, GLOBAL_BLACKBOARD_NAME)


func _on_attack_cooldown_timer_timeout()->void:
	can_attack = true
