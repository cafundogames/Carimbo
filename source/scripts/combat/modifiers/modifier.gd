class_name Modifier
extends Resource
## An attack modifier to apply on damage or over time.

## [Hurtbox3D] variable for easy access
var hurtbox: Hurtbox3D


## Initial function for the modifier. In here it must apply any changes about said modifier,
## including passing the [Hurtbox3D]
func apply(hb: Hurtbox3D) -> void:
	self.hurtbox = hb


## Function to give an active modifier to apply changes over time.
## It returns a [bool]ean to indicate if the modifier finished applying changes or not.
## Should return true when finished and false when not.
func process(delta: float) -> bool:
	return delta != 0.0
