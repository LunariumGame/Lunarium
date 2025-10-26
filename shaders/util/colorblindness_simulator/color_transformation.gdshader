shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform mat3 color_matrix;


void fragment() {
    vec3 c = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;

	COLOR.rgb = color_matrix * c.rgb;
}