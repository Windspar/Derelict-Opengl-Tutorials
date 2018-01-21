#version 330 core
out vec4 FragColor;
in vec2 TexCoords;

uniform sampler2D texture1;
uniform sampler2D texture2;

void main()
{
    vec2 coords = vec2(TexCoords.x, 1.0 - TexCoords.y);
    FragColor = mix(texture(texture1, TexCoords), texture(texture2, coords), 0.2);
}
