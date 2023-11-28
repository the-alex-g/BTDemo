extends ConditionLeaf


func tick(actor:Node, _blackboard:Blackboard)->int:
	if actor.can_attack:
		return SUCCESS
	return FAILURE
