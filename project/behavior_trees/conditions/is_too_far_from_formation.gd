extends ConditionLeaf

const FORMATION_TIGHTNESS := 50.0


func tick(actor:Node, blackboard:Blackboard)->int:
	if _get_distance_squared_between(
		actor.global_position,
		blackboard.get_value(actor.formation_index, null, actor.GLOBAL_BLACKBOARD_NAME).formation_center
	) > pow(FORMATION_TIGHTNESS, 2.0):
		return SUCCESS
	
	return FAILURE


func _get_distance_squared_between(from:Vector2, to:Vector2)->float:
	return from.distance_squared_to(to)
