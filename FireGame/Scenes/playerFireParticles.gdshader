shader_type canvas_item;

uniform float density = 0.5;
uniform int pixelation_factor = 1; // Default value, can be adjusted in the Godot editor
uniform float randomv2;

float hash(vec2 p){
    p = 50.0 * fract(p * 0.3183099 + vec2(0.71, 0.113));
    return fract(p.x * p.y * (p.x + p.y));
}

void fragment() {
	vec2 texture_size =  vec2(textureSize(TEXTURE,0));
	vec2 pixel_size = vec2(float(pixelation_factor));
	vec2 half_pixel = pixel_size / texture_size / 2.0;
	vec2 pixel_index = floor(UV * texture_size / pixel_size);
	vec2 pixel_center = (pixel_index + 0.5) * pixel_size / texture_size;

	
	float random_value = hash(pixel_center+randomv2);
	
	vec4 new_color = vec4(0,0,0,0);
	vec4 original_color = texture(TEXTURE, pixel_center);
    
    if (random_value > density){
        COLOR = original_color;
    } else {
        COLOR = new_color;
    }
}
