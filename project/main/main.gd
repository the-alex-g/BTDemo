extends Node2D

var _battle_started := false

@onready var _soldier_container : Node2D = $SoldierContainer
@onready var _blackboard : Blackboard = $Blackboard


func _on_soldier_placement_interface_soldier_instance_requested(soldier:Soldier)->void:
	if _battle_started:
		return
	
	soldier.disabled = true
	soldier.set_behavior_tree_blackboard(_blackboard)
	_soldier_container.add_child(soldier)


func _on_soldier_placement_interface_battle_started()->void:
	_set_soldiers_disabled(false)
	_battle_started = true


func _set_soldiers_disabled(disabled:bool)->void:
	for soldier in _soldier_container.get_children():
		soldier.disabled = disabled
