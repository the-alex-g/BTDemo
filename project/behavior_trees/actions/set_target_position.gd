extends ActionLeaf


func tick(actor:Node, blackboard:Blackboard)->int:
	actor.target_location = blackboard.get_value("target", null, str(actor.unit_index)).global_position
	return SUCCESS
