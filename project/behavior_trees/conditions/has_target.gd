extends ConditionLeaf


func tick(actor:Node, blackboard:Blackboard)->int:
	if is_instance_valid(blackboard.get_value("target", null, str(actor.unit_index))):
		return SUCCESS
	return FAILURE
