shader_type spatial;

uniform sampler2D displacement_map: repeat_enable;
uniform sampler2D liquid: repeat_enable;
uniform sampler2D color_ramp: source_color;
uniform float glow_strength: hint_range(0.0, 10.0, 0.1) = 2.0;
uniform float glow_oscillation: hint_range(0.0, 1.0, 0.1) = 0.0;
uniform float displacement_strength: hint_range(0.0, 1.0, 0.01) = 0.1;
uniform vec3 displacement_vector = vec3(0.0);
uniform float displacement_speed: hint_range(0.0, 10.0, 0.1) = 1.0;
uniform vec2 uv_scale = vec2(1.0, 1.0);
uniform vec2 uv_offset = vec2(1.0, 1.0);
uniform vec2 uv_offset2 = vec2(1.0, 0.0);
uniform float mix_amount: hint_range(0.0, 1.0, 0.01) = 0.5;

void vertex() {
	vec2 uv_mod = (UV - 0.5) * uv_scale + 0.5
		 + uv_offset * TIME * displacement_speed;

	vec2 uv_mod2 = (UV - 0.5) * uv_scale + 0.5
		 + uv_offset2 * TIME * displacement_speed;

	float map2 = texture(displacement_map, uv_mod2).r;
	float displacement = mix(texture(liquid, uv_mod).r, map2, mix_amount);

	float centered = (displacement * 2.0 - 1.0) ;
	VERTEX += displacement_vector * centered * displacement_strength;
}

void fragment() {
	vec2 uv_mod = (UV - 0.5) * uv_scale + 0.5
		 + uv_offset * TIME * displacement_speed;

	vec2 offset_90 = vec2(-uv_offset.y, uv_offset.x);
	vec2 uv_mod2 = (UV - 0.5) * uv_scale + 0.5
		 + uv_offset2 * TIME * displacement_speed;

	float map2 = texture(displacement_map, uv_mod2).r;
	float map = mix(texture(liquid, uv_mod).r, map2, mix_amount);

	vec4 color = texture(color_ramp, vec2(map, 0.0));
	ALBEDO = color.rgb;
	ALPHA = color.a;

	float glow = glow_strength;
	EMISSION = color.rgb * map * glow;
}
