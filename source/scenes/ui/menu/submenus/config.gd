extends Submenu

@onready var fullscreen: AnimatedCheckButton = %Fullscreen
@onready var music_slider: HSlider = %MusicSlider
@onready var sounds_slider: HSlider = %SoundsSlider

func _ready() -> void:
	super()
	var a: ConfigHandler.AudioSettings = SaveSys.load_audio_settings()
	music_slider.value = a.music_volume
	sounds_slider.value = a.sounds_volume
	fullscreen.toggled.connect(_on_fullscreen_toggled)
	fullscreen.set_pressed(SaveSys.load_video_settings().fullscreen)
	fullscreen.grab_focus()


func _on_back_button_pressed(source: AnimatedButton) -> void:
	_disable_buttons()
	source.burned.connect(change_menu.emit.bind(Consts.MENUS["main"]), CONNECT_ONE_SHOT)


func _on_sounds_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(Consts.BUS_SOUNDS, value)
	SaveSys.save_audio_setting("sounds", value)


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(Consts.BUS_MUSIC, value)
	SaveSys.save_audio_setting("music", value)


func _on_fullscreen_toggled(toggle: bool) -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN \
		if toggle else DisplayServer.WINDOW_MODE_WINDOWED)
	SaveSys.save_video_setting("fullscreen", toggle)
