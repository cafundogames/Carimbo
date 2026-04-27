extends Submenu

@onready var back_button: AnimatedButton = %BackButton

func _ready() -> void:
	super._ready()
	back_button.grab_focus()


func _on_back_button_pressed(source: AnimatedButton) -> void:
	_disable_buttons()
	source.burned.connect(change_menu.emit.bind(Consts.MENUS["main"]), CONNECT_ONE_SHOT)
