extends Node2D

@onready var _soldier_container : Node2D = $SoldierContainer
@onready var _blackboard : Blackboard = $Blackboard


func _ready()->void:
	for soldier in _soldier_container.get_children():
		soldier.set_behavior_tree_blackboard(_blackboard)
