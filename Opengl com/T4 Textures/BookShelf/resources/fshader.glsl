#version 330 core
out vec4 FragColor;
in vec3 ourColor;
in vec2 TexCoords;

uniform bool doColor;
uniform sampler2D ourTexture;

void main()
{
    if(doColor == true)
        FragColor = texture(ourTexture, TexCoords) * vec4(ourColor, 1.0);
    else
        FragColor = texture(ourTexture, TexCoords);
}
