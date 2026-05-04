class_name PoisonModifier
extends Modifier
## An attack modifier that applies poison damage over time

const _POISON_STAMP_TEXTURE: Texture2D = preload("uid://dttvady2su02o")

## How much time the poison will last in seconds
@export var duration: float = 10.0

var _time_left: float
var _loop_time: float = 0.0


## Initial function for the modifier. In here it will check if the target does not already have
## poison.[br]
## If not it will apply itself to the target [member Hurtbox3D.active_modifiers].[br]
## If yes it will simply change the time left on the old poison to the
## greater value
func apply(hb: Hurtbox3D) -> void:
	super(hb)
	self._time_left = self.duration
	var modidx: int = hb.active_modifiers.find_custom(
		func(mod: Modifier) -> bool: return mod is PoisonModifier
	)
	if modidx != -1:
		var old_poison: PoisonModifier = hb.active_modifiers.get(modidx)
		old_poison._time_left = maxf(old_poison._time_left, self._time_left)
		return
	hb.active_modifiers.push_back(self)


## Function to give an active modifier to apply changes over time.
## In here it will count down the time left and cause damage
## every second, returning true when finished
func process(delta: float) -> bool:
	_time_left -= delta
	_loop_time = 1.0 if _loop_time <= 0.0 else _loop_time - delta

	if _loop_time <= 0.0:
		var attk: AttackData = AttackData.new()
		attk.attack_dmg = 2.0
		attk.shield_dmg = 2.0
		attk.stamp_texture = _POISON_STAMP_TEXTURE
		attk.stamp_size = Vector2.ONE * 0.3
		self.hurtbox.emit_success_hit(attk)

	return _time_left <= 0.0
