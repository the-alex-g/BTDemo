class_name SoldierAnimations
extends Resource

const ANIM_NAMES := [
	"walk",
	"idle",
	"run",
]

@export var frame_size := Vector2(16, 16)
@export_group("Attack")
@export var attack_sprite_sheet : Texture2D
@export var attack_frames_per_second := 5
@export_group("Idle")
@export var idle_sprite_sheet : Texture2D
@export var idle_frames_per_second := 5
@export_group("Walk")
@export var walk_sprite_sheet : Texture2D
@export var walk_frames_per_second := 5

var _sprite_frames : SpriteFrames


func get_sprite_frames()->SpriteFrames:
	_sprite_frames = SpriteFrames.new()
	
	for animation_name in ANIM_NAMES:
		_add_animation_to_sprite_frames(animation_name)
	
	return _sprite_frames


func _add_animation_to_sprite_frames(animation_name:String)->void:
	var animation_texture := _get_animation_texture(animation_name)
	
	if animation_texture == null:
		return
	
	_sprite_frames.add_animation(animation_name)
	_sprite_frames.set_animation_speed(animation_name, _get_animation_speed(animation_name))
	
	var v_frames : int = floor(animation_texture.get_height() / frame_size.y)
	var h_frames : int = floor(animation_texture.get_width() / frame_size.x)
	
	for y in v_frames:
		for x in h_frames:
			var frame := _generate_frame_texture(x, y, animation_texture)
			if frame != null:
				_sprite_frames.add_frame(animation_name, frame)


func _get_animation_speed(animation_name:String)->float:
	return get(animation_name + "_frames_per_second")


func _get_animation_texture(animation_name:String)->Texture2D:
	return get(animation_name + "_sprite_sheet")


func _generate_frame_texture(x:int, y:int, texture:Texture2D)->AtlasTexture:
	var frame_texture := AtlasTexture.new()
	frame_texture.atlas = texture
	frame_texture.region = Rect2(
		frame_size * Vector2(x, y),
		frame_size
	)
	if _is_frame_empty(frame_texture):
		return null
	return frame_texture


func _is_frame_empty(frame_texture:Texture2D)->bool:
	var frame_image := frame_texture.get_image()
	for x in floor(frame_size.x):
		for y in floor(frame_size.y):
			if frame_image.get_pixel(x, y).a > 0.0:
				return false
	return true
