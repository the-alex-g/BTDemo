extends ConditionLeaf


func tick(actor:Node, blackboard:Blackboard)->int:
	if _get_distance_squared_between(actor, blackboard.get_value("target", null, str(actor.unit_index))) < pow(actor.config.attack_range, 2.0):
		return SUCCESS
	return FAILURE


func _get_distance_squared_between(from:Node2D, to:Node2D)->float:
	return from.global_position.distance_squared_to(to.global_position)
