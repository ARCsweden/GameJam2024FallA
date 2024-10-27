shader_type canvas_item;

uniform float Strength : hint_range(0, 40) = 5.0;
uniform float Speed : hint_range(0.0, 10.0) = 1.0;

void vertex()
{
    // Add slight randomness by incorporating vertex coordinates with unique frequency and phase offsets
    float x_offset = sin(VERTEX.y * 0.15 + TIME * Speed + VERTEX.x * 0.3) * Strength;
    float y_offset = cos(VERTEX.x * 0.15 + TIME * Speed + VERTEX.y * 0.3) * Strength;

    // Apply the calculated offsets to the vertex position
    VERTEX.x += x_offset;
    VERTEX.y += y_offset;
}
