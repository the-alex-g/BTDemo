@icon("res://resources/icons/soldier_config.png")
class_name SoldierConfig
extends Resource

enum AttackType {MELEE, RANGED}
enum TargetType {
	NO_PREFERENCE,
	LOW_HEALTH,
	HIGH_HEALTH,
	DAMAGED,
	HIGH_DAMAGE_OUTPUT,
}
enum TargetDistance {CLOSE, FAR}

@export_category("Name")
@export var soldier_name := ""
@export var soldier_icon : Texture2D
@export_category("Targeting")
@export var target_enemies := true
@export var target_allies := false
@export var target_type := TargetType.NO_PREFERENCE
@export var target_distance := TargetDistance.CLOSE
@export_category("Attacking")
@export var attack_type := AttackType.MELEE
@export var attack_range := 100.0
@export var attack_statuses : Array[StatusEffect.StatusType] = []
@export_group("Cooldown")
@export var attack_cooldown_time := 1.0
@export var cooldown_time_variance := 0.25 : get = _get_cooldown_time_variance
@export_group("Damage")
@export var damage := 5
@export var damage_variance := 1 : get = _get_damage_variance
@export_category("Stats")
@export var health := 20 : set = _set_health
@export var speed := 150.0
@export var status_immunities : Array[StatusEffect.StatusType] = []
@export_category("Animations")
@export var animations : SoldierAnimations

var max_health := 0


func _set_health(value:int)->void:
	health = value
	if health > max_health:
		max_health = health


func _get_cooldown_time_variance()->float:
	return clamp(cooldown_time_variance, 0.0, attack_cooldown_time)


func _get_damage_variance()->int:
	return clamp(damage_variance, 0, damage)


func get_attack_statuses()->Array[StatusEffect]:
	var statuses : Array[StatusEffect] = []
	for status_type in attack_statuses:
		statuses.append(StatusEffect.get_status_node(status_type))
	return statuses


func is_immune_to(status:StatusEffect)->bool:
	return status_immunities.has(status.type)
