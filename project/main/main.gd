extends Node2D

const GLOBAL_BLACKBOARD_NAME := "global"

var _is_battle_in_progress := false
var _team_sizes := {}

@onready var _soldier_container : Node2D = $SoldierContainer
@onready var _blackboard : Blackboard = $Blackboard


func _on_soldier_placement_interface_soldier_instance_requested(soldier:Soldier)->void:
	if _is_battle_in_progress:
		return
	
	soldier.disabled = true
	soldier.team_index = 0 if soldier.position.x < 512 else 1
	soldier.set_behavior_tree_blackboard(_blackboard)
	soldier.died.connect(_on_soldier_died)
	_soldier_container.add_child(soldier)
	_increment_team(soldier.team_index)


func _increment_team(team:int)->void:
	if _team_sizes.has(team):
		_team_sizes[team] += 1
	else:
		_team_sizes[team] = 1


func _decrement_team(team:int)->void:
	_team_sizes[team] -= 1


func _on_soldier_placement_interface_battle_started()->void:
	if not _is_battle_in_progress:
		_set_soldiers_disabled(false)
		_is_battle_in_progress = true


func _set_soldiers_disabled(disabled:bool)->void:
	for soldier in _soldier_container.get_children():
		soldier.disabled = disabled


func _on_soldier_died(soldier:Soldier)->void:
	_decrement_team(soldier.team_index)
	_remove_extinct_teams()
	if _is_battle_in_progress:
		_check_for_battle_end()


func _remove_extinct_teams()->void:
	for team_index in _team_sizes:
		if _team_sizes[team_index] == 0:
			_team_sizes.erase(team_index)


func _check_for_battle_end()->void:
	if _team_sizes.size() <= 1:
		_end_battle()


func _end_battle()->void:
	_set_soldiers_disabled(true)
	_is_battle_in_progress = false
	print("Battle over! Team ", _team_sizes.keys()[0], " won!")


func _make_formation(formation_nodes:Array[Node])->void:
	
	var formation := Formation.new()
	formation.index = _blackboard.get_value("formation_counter", 0, GLOBAL_BLACKBOARD_NAME)
	formation.members = formation_nodes
	formation.dissolved.connect(_on_formation_dissolved)
	
	_increment_blackboard_int("formation_counter", _blackboard)
	
	_blackboard.set_value(formation.index, formation, GLOBAL_BLACKBOARD_NAME)


func _increment_blackboard_int(field_name:String, blackboard:Blackboard)->void:
	blackboard.set_value(
		field_name,
		blackboard.get_value(field_name, 0, GLOBAL_BLACKBOARD_NAME) + 1,
		GLOBAL_BLACKBOARD_NAME
	)


func _on_formation_dissolved(formation:Formation)->void:
	_blackboard.erase_value(formation.index, GLOBAL_BLACKBOARD_NAME)


func _on_selection_actions_make_formation(members:Array[Node])->void:
	_make_formation(members)
