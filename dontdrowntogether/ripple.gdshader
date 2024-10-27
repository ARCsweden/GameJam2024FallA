shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec2 ripple_center = vec2(0.5, 0.5); // Center of the ripple
uniform float ripple_speed : hint_range(0.1, 5.0) = 1.0; // Speed of ripple expansion
uniform float ripple_frequency : hint_range(0.1, 20.0) = 10.0; // Frequency of ripple waves
uniform float ripple_amplitude : hint_range(0.0, 0.1) = 0.02; // Amplitude of ripple (distortion strength)
uniform float fade_distance : hint_range(0.1, 2.0) = 1.0; // Distance over which ripple fades

void fragment() {
    // Get the current UV coordinates
    vec2 uv = SCREEN_UV;

    // Calculate distance from the ripple center
    vec2 dir = uv - ripple_center;
    float dist = length(dir);

    // Calculate ripple effect based on distance and time
    float ripple = sin((dist - ripple_speed * TIME) * ripple_frequency) * ripple_amplitude;

    // Fade out ripple based on distance
    ripple *= smoothstep(fade_distance, 0.0, dist);

    // Apply ripple distortion to UV coordinates
    vec2 ripple_uv = uv + normalize(dir) * ripple;

    // Sample the screen texture with the distorted UV coordinates
    vec4 screen_col = texture(SCREEN_TEXTURE, ripple_uv);
	
	    // Set the final color with distortion
    COLOR = screen_col;
	}