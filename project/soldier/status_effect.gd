class_name StatusEffect
extends Node

static var _status_type_to_node = {
	StatusType.UNTYPED:StatusEffect,
	StatusType.BLEED:Bleed
}

enum StatusType {UNTYPED, BLEED}

@export var period := 1.0
@export var duration := 3

var _effect_timer : Timer
@warning_ignore("unused_private_class_variable")
var type := StatusType.UNTYPED

@warning_ignore("unused_private_class_variable")
@onready var _affected_node : Soldier = get_parent()


func _ready()->void:
	_add_timer()


func _add_timer()->void:
	_effect_timer = Timer.new()
	add_child(_effect_timer)
	_effect_timer.start(period)
	_effect_timer.timeout.connect(_evaluate)


func _evaluate()->void:
	duration -= 1
	if duration <= 0:
		_remove_status()


func _remove_status()->void:
	queue_free()


static func get_status_node(status_type:StatusType)->StatusEffect:
	return _status_type_to_node[status_type].new()
