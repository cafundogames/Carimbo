@tool
class_name ShadedAnimatedSprite3D
extends AnimatedSprite3D

signal burned

const SHADER_STAMPABLE_SPRITE: ShaderMaterial = preload("uid://brb72iyoqsyk6")
const BURN_SFX = preload("uid://dfe4v2sdvd1bd")

@export var audio_player: AudioStreamPlayer
@export var stamp_viewport: SubViewport:
	set = set_stamp_viewport
@export var stamp_viewport_texture: ViewportTexture:
	set = set_stamp_viewport_texture


func _init() -> void:
	if not Engine.is_editor_hint():
		return
	if not material_override:
		material_override = SHADER_STAMPABLE_SPRITE.duplicate()
	if not sprite_frames:
		sprite_frames = SpriteFrames.new()


func _ready() -> void:
	if not audio_player:
		audio_player = AudioStreamPlayer.new()
		add_child(audio_player)
	frame_changed.connect(_update_shader_anim)
	animation_changed.connect(_update_shader_anim)
	_update_viewport_size()
	_update_shader_anim()


func _get_configuration_warnings() -> PackedStringArray:
	var war: PackedStringArray = []
	if not stamp_viewport:
		war.append("Select a SubViewport node for the stamp effect")
	return war


func set_stamp_viewport(new: SubViewport) -> void:
	stamp_viewport = new
	_update_viewport_size()
	update_configuration_warnings()


func set_stamp_viewport_texture(new: ViewportTexture) -> void:
	stamp_viewport_texture = new
	if not stamp_viewport:
		return
	var material: ShaderMaterial = material_override
	material.set_shader_parameter.call_deferred(&"texture_carimbo", stamp_viewport_texture)


## "Carimba" uma imagem em algum lugar aleatório da imagem
func stamp(image: Texture2D, size: Vector2 = Vector2(1.0, 1.0)) -> void:
	var vp_size = stamp_viewport.size

	# anda até 1/4 do tamanho do viewport pra algum lado
	var r = vp_size / 4.0
	var pos_offset = Vector2(randi_range(-r.x, r.x), randi_range(-r.y, r.y))
	var rot = deg_to_rad(randf_range(-50.0, 50.0))

	var pos = vp_size / 2.0 + pos_offset
	stamp_offset(image, pos, size, rot)


## Desenha uma imagem por cima do sprite = null
func stamp_offset(image: Texture2D, pos: Vector2, size: Vector2, rot: float) -> void:
	var sprite = Sprite2D.new()
	sprite.position = pos
	sprite.scale = size
	sprite.rotation = rot
	sprite.texture = image
	stamp_viewport.add_child(sprite)

	# Faz o viewport atualizar no próximo frame
	stamp_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	# Apaga o sprite depois do fim do próximo frame
	get_tree().process_frame.connect(
		func():
			get_tree().process_frame.connect(sprite.queue_free, CONNECT_ONE_SHOT),
		CONNECT_ONE_SHOT,
	)


## Executa o efeito de burn
func trigger_burn_fx(sound: bool = true, burn_time: float = 1.0) -> void:
	if sound and audio_player:
		audio_player.reparent(get_tree().current_scene)
		audio_player.stream = BURN_SFX
		audio_player.finished.connect(audio_player.queue_free, CONNECT_ONE_SHOT)
		audio_player.play()
	var particles: GPUParticles3D = Consts.PARTICLE_SPARK.instantiate()
	get_tree().current_scene.add_child(particles)
	particles.global_position = global_position
	if not particles.finished.is_connected(particles.queue_free):
		particles.finished.connect(particles.queue_free, CONNECT_ONE_SHOT)
	particles.emitting = true

	var burn_tween: Tween = create_tween()
	burn_tween.tween_property(
		material_override,
		^"shader_parameter/burn_amount",
		1.0,
		burn_time,
	).from(0.0)
	burn_tween.finished.connect(burned.emit)


## Chamada quando a hitbox leva dano para carimbar o sprite
func on_hitbox_damaged(info: AttackInfo) -> void:
	stamp(info.stamp_texture if info.stamp_texture else Consts.CARIMBO, info.stamp_size)


func clear_viewport() -> void:
	stamp_viewport.render_target_clear_mode = SubViewport.CLEAR_MODE_ONCE
	stamp_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE


## Atualiza o tamanho do viewport de carimbos de acordo com a animação
func _update_viewport_size() -> void:
	if not sprite_frames or not stamp_viewport:
		return
	var max_x: int = 256
	var max_y: int = 256

	# Itera por cada frame de cada animação
	if sprite_frames:for anim in sprite_frames.get_animation_names():
		for f in sprite_frames.get_frame_count(anim):
			var tex = sprite_frames.get_frame_texture(anim, f)
			max_x = max(max_x, tex.get_width())
			max_y = max(max_y, tex.get_height())

	stamp_viewport.set_size(Vector2(max_x, max_y))
	stamp_viewport.set_clear_mode(SubViewport.CLEAR_MODE_ONCE)
	stamp_viewport.set_update_mode(SubViewport.UPDATE_ONCE)
	stamp_viewport.set_transparent_background(true)
	stamp_viewport.set_disable_3d(true)


## Atualiza a texture no shader de acordo com a animação atual
func _update_shader_anim() -> void:
	if not material_override:
		return
	var material: ShaderMaterial = material_override

	var curr_frame = sprite_frames.get_frame_texture(animation, frame)
	# Caso onde o frame atual é um parte de um atlas
	if curr_frame is AtlasTexture:
		# Atlas do frame atual
		var atlas: Texture2D = curr_frame.atlas
		var atlas_size = atlas.get_size()

		# Posição e tamanho normalizados do atlas
		var curr_rect = curr_frame.region
		var curr_pos = curr_rect.position / atlas_size
		var curr_size = curr_rect.size / atlas_size
		var normal_rect = Vector4(curr_pos.x, curr_pos.y, curr_size.x, curr_size.y)

		material.set_shader_parameter("region_rect", normal_rect)
	else:
		material.set_shader_parameter("region_rect", Vector4(0.0, 0.0, 1.0, 1.0))

	material.set_shader_parameter("texture_albedo", curr_frame)
