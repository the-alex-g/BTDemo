class_name Soldier
extends CharacterBody2D

signal died(soldier)

const DISTANCE_BUFFER := 2.0
const GLOBAL_BLACKBOARD_NAME := "global"
const ATTACK_COOLDOWN_VARIANCE_PERCENTAGE := 0.25

@export var config : SoldierConfig
@export var team_index := 0

var target_location := -Vector2.ONE
var unit_index := -1
var can_attack := true
var disabled := false : set = _set_disabled
var selected := false : set = _set_selected
var is_in_formation : bool : get = _get_is_in_formation
var _has_been_added_to_tree := false
var formation_index := -1

@onready var _behavior_tree : BeehaveTree = $BeehaveTree
@onready var _attack_cooldown_timer : Timer = $AttackCooldownTimer
@onready var _sprite : AnimatedSprite2D = $AnimatedSprite2D


func _ready()->void:
	if config == null:
		print(name, " doesn't have a config!")
		config = SoldierConfig.new()
	
	_sprite.sprite_frames = config.animations.get_sprite_frames()
	_sprite.scale = config.animations.scale
	_play_animation("idle")
	
	_has_been_added_to_tree = true
	
	if team_index == 1:
		modulate = Color.RED


func _physics_process(delta:float)->void:
	if disabled:
		_play_animation("idle")
		return
	
	if _can_move() and not _is_at_target():
		_move_towards_target_location(delta)
		_play_animation("walk")
	else:
		_play_animation("idle")


func _can_move()->bool:
	if target_location < Vector2.ZERO:
		return false
	return true


func _is_at_target()->bool:
	if target_location.distance_squared_to(global_position) < pow(DISTANCE_BUFFER, 2.0):
		return true
	return false


func _play_animation(animation_name:String)->void:
	if not _sprite.animation == "attack" or not _sprite.is_playing():
		if _sprite.animation != animation_name:
			_sprite.play(animation_name)


func _move_towards_target_location(delta:float)->void:
	_sprite.look_at(target_location)
	var angle := get_angle_to(target_location)
	var motion := Vector2.RIGHT.rotated(angle) * delta * config.speed
	move_and_collide(motion)
	target_location = -Vector2.ONE


func attack()->Attack:
	_start_attack_cooldown()
	_play_animation("attack")
	return _generate_attack()


func _start_attack_cooldown()->void:
	can_attack = false
	_attack_cooldown_timer.start(_get_attack_cooldown_time())


func _get_attack_cooldown_time()->float:
	return config.attack_cooldown_time + randf_range(-config.cooldown_time_variance, config.cooldown_time_variance)


func _generate_attack()->Attack:
	var new_attack := Attack.new()
	new_attack.damage = _get_attack_damage()
	new_attack.statuses = config.get_attack_statuses()
	return new_attack


func _get_attack_damage()->int:
	return config.damage + randi_range(-config.damage_variance, config.damage_variance)


func hit_with_attack(incoming_attack:Attack)->void:
	damage(incoming_attack.damage)
	for status in incoming_attack.statuses:
		apply_status(status)


func damage(amount:int)->void:
	config.health -= amount
	if config.health <= 0:
		queue_free()



func _remove_data_from_blackboard(blackboard:Blackboard)->void:
	_erase_item_from_blackboard_array("units", unit_index, blackboard)
	_erase_item_from_blackboard_array("actor_list", self, blackboard)


func _erase_item_from_blackboard_array(array_name:String, item:Variant, blackboard:Blackboard)->void:
	var stored : Array = blackboard.get_value(array_name, [], GLOBAL_BLACKBOARD_NAME)
	stored.erase(item)
	blackboard.set_value(array_name, stored, GLOBAL_BLACKBOARD_NAME)


func apply_status(status:StatusEffect)->void:
	if not config.is_immune_to(status):
		add_child(status)


func set_behavior_tree_blackboard(blackboard:Blackboard)->void:
	unit_index = blackboard.get_value("unit_counter", 0, GLOBAL_BLACKBOARD_NAME)
	
	_increment_blackboard_int("unit_counter", blackboard)
	_append_item_to_blackboard_array("units", unit_index, blackboard)
	_append_item_to_blackboard_array("actor_list", self, blackboard)
	
	if not _has_been_added_to_tree:
		await ready
	_behavior_tree.blackboard = blackboard


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


func _set_disabled(value:bool)->void:
	disabled = value
	if not _has_been_added_to_tree:
		await ready
	_behavior_tree.enabled = not disabled


func _set_selected(value:bool)->void:
	selected = value
	queue_redraw()


func _get_is_in_formation()->bool:
	return _behavior_tree.blackboard.has_value(formation_index, GLOBAL_BLACKBOARD_NAME)


func _draw()->void:
	if selected and disabled:
		draw_arc(Vector2.ZERO, config.animations.frame_size.length() / 2 + 4, 0.0, TAU, 32, Color.GOLD)
	if formation_index > -1:
		draw_char(
			Label.new().get_theme_default_font(),
			Vector2.DOWN * (config.animations.frame_size.y + 10),
			str(formation_index),
		)


func _on_tree_exiting()->void:
	_remove_data_from_blackboard(_behavior_tree.blackboard)
	died.emit(self)
