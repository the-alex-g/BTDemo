class_name Formation
extends Resource

signal dissolved(formation)

var members : Array[Node] = [] : set = _set_members
var formation_center : Vector2 : get = _get_formation_center
var index := -1 : set = _set_index
var _last_frame_formation_center_updated : float = -1


func add_member(member:Node)->void:
	members.append(member)
	member.formation_index = index
	member.died.connect(_on_member_died.bind(member))


func _get_formation_center()->Vector2:
	if Engine.get_process_frames() != _last_frame_formation_center_updated:
		_update_formation_center()
	
	return formation_center


func _update_formation_center()->void:
	_last_frame_formation_center_updated = Engine.get_process_frames()
	
	var total_formation_position := Vector2.ZERO
	for member in members:
		if is_instance_valid(member):
			total_formation_position += member.global_position
	
	formation_center = total_formation_position / members.size()


func _set_members(value:Array[Node])->void:
	members = value
	for member in members:
		member.formation_index = index
		member.died.connect(_on_member_died)


func _set_index(value:int)->void:
	index = value
	for member in members:
		member.formation_index = index


func _on_member_died(member:Node)->void:
	members.erase(member)
	if members.size() <= 1:
		dissolved.emit(self)
