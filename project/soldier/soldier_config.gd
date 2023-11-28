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

@export_category("Targeting")
@export var target_enemies := true
@export var target_allies := false
@export var target_type := TargetType.NO_PREFERENCE
@export var target_distance := TargetDistance.CLOSE
@export_category("Attacking")
@export var attack_type := AttackType.MELEE
@export var attack_range := 100.0
@export var attack_cooldown_time := 1.0
@export_category("Stats")
@export var soldier_stats := SoldierStats.new(5, 20)
