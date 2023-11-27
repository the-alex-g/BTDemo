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

@export var target_enemies := true
@export var target_allies := false
@export var attack_type := AttackType.MELEE
@export var target_type := TargetType.NO_PREFERENCE
@export var target_distance := TargetDistance.CLOSE
@export var soldier_stats := SoldierStats.new(5, 20)
@export var attack_range := 10.0
