shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, repeat_disable, filter_nearest;
uniform float time;
uniform float intensity : hint_range(0.0, 1.0);

void fragment() {
	vec3 color = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	
	color.r = abs(sin(time + color.r * 3.14));
    color.g = abs(sin(time + color.g * 3.14 + 2.0));
    color.b = abs(sin(time + color.b * 3.14 + 4.0));
	
	COLOR.rgb = mix(texture(SCREEN_TEXTURE, SCREEN_UV).rgb, color, intensity);
	// COLOR.rgb = color;
}
