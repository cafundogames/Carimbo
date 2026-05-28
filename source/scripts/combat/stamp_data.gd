class_name StampData
extends Resource

enum StampAttackType {
	MELEE,
	RANGED,
}

const ATTACK_MELEE = StampAttackType.MELEE
const ATTACK_RANGED = StampAttackType.RANGED

@export var stamp_scene: PackedScene
@export_range(0.1, 1.0, 0.1, "or_greater", "suffix:sec") var stamp_cooldown: float = 0.5
@export var stamp_type: StampAttackType = StampAttackType.MELEE
@export_group("UI", "ui_")
@export var ui_icon: Texture2D
@export var ui_icon_large: Texture2D
