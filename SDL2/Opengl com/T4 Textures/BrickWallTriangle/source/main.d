import common.sdl.common;

void main()
{
    if(!setupScreen("Brick Wall Triangle", 800, 600))
        return;

    GLuint brickWall = loadImage("resources/brick_wall.jpg");
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    float[] vertices = [
         0.5f, -0.5f, 0.0f,     0.0f, 0.0f,
        -0.5f, -0.5f, 0.0f,     1.0f, 0.0f,
         0.0f,  0.5f, 0.0f,     0.5f, 1.0f ];

    VertexArray vao = VertexArray(1).bind();
    VertexBuffer vbo = VertexBuffer(1).bind(GL_ARRAY_BUFFER);
    vbo.data(GL_ARRAY_BUFFER, vertices.glSizeof(), vertices.ptr, GL_STATIC_DRAW);
    vao.attribute(0, 3, GL_FLOAT, GL_FALSE, 5 * GLfloat.sizeof, cast(void*)0);
    vao.attribute(1, 2, GL_FLOAT, GL_FALSE, 5 * GLfloat.sizeof, cast(void*)(3 * GLfloat.sizeof));
    vao.unbind();

    ShaderProgram shader = ShaderProgram("resources/vshader.glsl","resources/fshader.glsl");

    glClearColor(0.1f, 0.0f, 0.0f, 1.0f);
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

        glClear(GL_COLOR_BUFFER_BIT);
        shader.use();
        glBindTexture(GL_TEXTURE_2D, brickWall);
        vao.bind();
        glDrawArrays(GL_TRIANGLES, 0, 3);
        vao.unbind();

        SDL_GL_SwapWindow(Screen.window);
        SDL_Delay(10);
    }
    vbo.destroy();
    vao.destroy();
    shader.destroy();
    cleanUp();
}
