class_name AttackData
extends Resource
## Resource for all Attack information, including damage, shield damage, stamp texture & size and
## modifiers

## The texture to be used for stamping the target's sprite
@export var stamp_texture: Texture2D
## The size of the stamp when stamping the target's sprite
@export_custom(PROPERTY_HINT_LINK, "") var stamp_size: Vector2 = Vector2.ONE
## The amount of damage to cause
@export var attack_dmg: float
## The amount of damage to cause to shields
@export var shield_dmg: float = 0.0
## An Array of [Modifier]s
@export var mods: Array[Modifier]
