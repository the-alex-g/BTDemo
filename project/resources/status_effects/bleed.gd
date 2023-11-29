class_name Bleed
extends StatusEffect

@export var damage := 1


func _init()->void:
	type = StatusType.BLEED


func _evaluate()->void:
	_affected_node.damage(damage)
	super._evaluate()
