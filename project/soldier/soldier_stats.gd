class_name SoldierStats
extends Resource

@export var damage := 0
@export var health := 0 : set = _set_health
@export var speed := 150.0

var max_health := 0


func _init(n_damage := damage, n_health := health, n_speed := speed) -> void:
	damage = n_damage
	_set_health(n_health)
	speed = n_speed


func _set_health(value:int)->void:
	health = value
	if health > max_health:
		max_health = health
