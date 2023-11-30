extends ActionLeaf


func tick(actor:Node, blackboard:Blackboard)->int:
	actor.target_location = blackboard.get_value(actor.formation_index, null, actor.GLOBAL_BLACKBOARD_NAME).formation_center
	return SUCCESS
