import common.sdl.common;
import std.math: sin;

void main()
{
    if(!setupScreen("Dim In & Out Triangle", 800, 600))
        return;

    float[] vertices = [
        -0.5f, -0.5f, 0.0f,
         0.5f, -0.5f, 0.0f,
         0.0f,  0.5f, 0.0f ];

    VertexArray vao = VertexArray(1).bind();
    VertexBuffer vbo = VertexBuffer(1).bind(GL_ARRAY_BUFFER);
    vbo.data(GL_ARRAY_BUFFER, vertices.glSizeof(), vertices.ptr, GL_STATIC_DRAW);
    vao.attribute(0, 3, GL_FLOAT, GL_FALSE, 3 * GLfloat.sizeof, cast(void*)0);
    vao.unbind();

    ShaderProgram shader = ShaderProgram("resources/vshader.glsl","resources/fshader.glsl");

    glClearColor(0.1f, 0.0f, 0.0f, 1.0f);
    uint timevalue;
    float greenValue;
    SDL_Event event;
    bool running = true;
    while(running)
    {
        while(SDL_PollEvent(&event) != 0)
        {
            if(event.type == SDL_KEYDOWN)
            {
                if(event.key.keysym.sym == SDLK_ESCAPE)
                    running = false;
            }
            else if(event.type == SDL_QUIT)
                running = false;
        }
        timevalue = SDL_GetTicks();
        greenValue = sin(timevalue * 0.001f) / 2.0f + 0.5f;

        glClear(GL_COLOR_BUFFER_BIT);
        shader.use();
        shader.uniform4f("ourColor", 0.0f, greenValue, 0.0f, 1.0f);
        vao.bind();
        glDrawArrays(GL_TRIANGLES, 0, 3);
        vao.unbind();

        SDL_GL_SwapWindow(Screen.window);
        SDL_Delay(10);
    }
    vbo.destroy();
    shader.destroy();
    cleanUp();
}
