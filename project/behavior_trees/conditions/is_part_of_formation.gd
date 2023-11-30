extends ConditionLeaf


func tick(actor:Node, _blackboard:Blackboard)->int:
	if actor.is_in_formation:
		return SUCCESS
	return FAILURE
