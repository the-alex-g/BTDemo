extends ActionLeaf

const MAX_TARGETS := 10


func tick(actor:Node, blackboard:Blackboard)->int:
	blackboard.set_value("target", _get_target(
		actor,
		_get_possible_targets(actor, blackboard.get_value("actor_list", [], actor.GLOBAL_BLACKBOARD_NAME))
	), str(actor.unit_index))
	
	if is_instance_valid(blackboard.get_value("target", null, str(actor.unit_index))):
		return SUCCESS
	return FAILURE


func _get_target(actor:Soldier, possible_targets:Array)->Node2D:
	possible_targets.sort_custom(_get_priority_sorting_function(actor))
	if possible_targets.size() > 0:
		return possible_targets.front()
	return null


func _get_priority_sorting_function(actor:Soldier)->Callable:
	var function := func(_a, _b): return true
	
	match actor.config.target_type:
		SoldierConfig.TargetType.LOW_HEALTH:
			function = func(a:Soldier, b:Soldier):
				return a.stats.health < b.stats.health
		
		SoldierConfig.TargetType.HIGH_HEALTH:
			function = func(a:Soldier, b:Soldier):
				return a.stats.health > b.stats.health
		
		SoldierConfig.TargetType.HIGH_DAMAGE_OUTPUT:
			function = func(a:Soldier, b:Soldier):
				return a.stats.damage > b.stats.damage
		
		SoldierConfig.TargetType.DAMAGED:
			function = func(a:Soldier, b:Soldier):
				return (a.stats.max_health - a.stats.health) > (b.stats.max_health - b.stats.health)
	
	return function


func _get_possible_targets(actor:Soldier, target_list:Array)->Array:
	var possible_targets : Array = _limit_targets_by_team(actor, target_list)
	target_list.sort_custom(_get_distance_sorting_function(actor))
	return possible_targets.slice(0, MAX_TARGETS)


func _limit_targets_by_team(actor:Soldier, possible_targets:Array)->Array:
	var trimmed_targets : Array = []
	for target in possible_targets:
		if is_instance_valid(target) and target != actor:
			if target.team_index == actor.team_index and actor.config.target_allies:
				trimmed_targets.append(target)
			if target.team_index != actor.team_index and actor.config.target_enemies:
				trimmed_targets.append(target)
	return trimmed_targets


func _get_distance_sorting_function(actor:Soldier)->Callable:
	var function := func(_a, _b):
		return true
	match actor.config.target_distance:
		SoldierConfig.TargetDistance.CLOSE:
			function = func(a:Node2D, b:Node2D):
				return _get_distance_squared_between(actor, a) < _get_distance_squared_between(actor, b)
		SoldierConfig.TargetDistance.FAR:
			function = func(a:Node2D, b:Node2D):
				return _get_distance_squared_between(actor, a) > _get_distance_squared_between(actor, b)
	return function


func _get_distance_squared_between(from:Node2D, to:Node2D)->float:
	return from.global_position.distance_squared_to(to.global_position)
