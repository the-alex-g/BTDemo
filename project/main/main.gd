extends Node2D

var _battle_started := false

var _team_sizes := {}
var foo := 0

@onready var _soldier_container : Node2D = $SoldierContainer
@onready var _blackboard : Blackboard = $Blackboard


func _on_soldier_placement_interface_soldier_instance_requested(soldier:Soldier)->void:
	if _battle_started:
		return
	
	soldier.disabled = true
	soldier.team_index = foo % 2
	foo += 1
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
	if not _battle_started:
		_set_soldiers_disabled(false)
		_battle_started = true


func _set_soldiers_disabled(disabled:bool)->void:
	for soldier in _soldier_container.get_children():
		soldier.disabled = disabled


func _on_soldier_died(soldier:Soldier)->void:
	_decrement_team(soldier.team_index)
	_remove_extinct_teams()
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
	print("Battle over! Team ", _team_sizes.keys()[0], " won!")
