extends ActionLeaf


func tick(actor:Node, blackboard:Blackboard)->int:
	var target : Soldier = blackboard.get_value("target", null, str(actor.unit_index))
	target.hit_with_attack(actor.generate_attack())
	
	return SUCCESS
