class_name AttackData
extends Resource
## Resource for all Attack information, including damage, shield damage, stamp texture & size and
## modifiers

## The texture to be used for stamping the target's sprite
var stamp_texture: Texture2D
## The size of the stamp when stamping the target's sprite
var stamp_size: Vector2
## The amount of damage to cause
var attack_dmg: float
## The amount of damage to cause to shields
var shield_dmg: float = 0.0
## An Array of [AttackData.Modifier]s
var mods: Array[Modifier]

## An attack modifier to apply on damage or over time.
class Modifier:
	## [Hurtbox3D] variable for easy access
	var hurtbox: Hurtbox3D


	## Initial function for the modifier. In here it must apply any changes about said modifier,
	## including passing the [Hurtbox3D]
	func apply(hb: Hurtbox3D) -> void:
		self.hurtbox = hb


	## Function to give an active modifier to apply changes over time.
	## It returns a [bool]ean to indicate if the modifier finished applying changes or not. [br]
	## Should return true when finished and false when not.
	func process(delta: float) -> bool:
		return delta != 0.0


class PoisonModifier extends Modifier:
	var time_left: float = 10


	func apply(hb: Hurtbox3D) -> void:
		super(hb)
		var modidx: int = hb.active_modifiers.find_custom(
			func(mod: Modifier) -> bool: return mod is PoisonModifier
		)
		if modidx != -1:
			var old_poison: PoisonModifier = hb.active_modifiers.get(modidx)
			old_poison.time_left = maxf(old_poison.time_left, self.time_left)
			return
		hb.active_modifiers.push_back(self)


	func process(delta: float) -> bool:
		time_left -= delta

		if fmod(time_left, 0.5) == 0.0:
			var attk: AttackData = AttackData.new()
			attk.attack_dmg = 2.0
			attk.shield_dmg = 2.0
			self.hurtbox.emit_success_hit(attk)

		return is_zero_approx(time_left)
