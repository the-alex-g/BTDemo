class_name Attack
extends Resource

var damage := 0
var statuses : Array[StatusEffect] = []


func _init(n_damage := damage, n_statuses := statuses) -> void:
	damage = n_damage
	statuses = n_statuses
