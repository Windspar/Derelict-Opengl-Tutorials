import common.sdl.common;

void main()
{
    if(!setupScreen("Box Triangle And WireFrame", 800, 600))
        return;

    GLfloat[] vertices = [
         0.5f,  0.5f, 0.0f,
         0.5f, -0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f,
        -0.5f,  0.5f, 0.0f ];

    GLint[] indices = [0,1,3, 1,2,3];

    VertexArray vao = VertexArray(1).bind();
    VertexBuffer vbo = VertexBuffer(1).bind(GL_ARRAY_BUFFER);
    vbo.data(GL_ARRAY_BUFFER, vertices.glSizeof(), vertices.ptr, GL_STATIC_DRAW);

    VertexBuffer ebo = VertexBuffer(1).bind(GL_ELEMENT_ARRAY_BUFFER);
    ebo.data(GL_ELEMENT_ARRAY_BUFFER, indices.glSizeof(), indices.ptr, GL_STATIC_DRAW);

    vao.attribute(0, 3, GL_FLOAT, GL_FALSE, 3 * GLfloat.sizeof, cast(void*)0);
    vao.unbind();

    ShaderProgram shader = ShaderProgram("resources/vshader.glsl","resources/fshader.glsl");

    bool lineMode = false;
    glClearColor(0.1f, 0.0f, 0.0f, 1.0f);
    SDL_Event event;
    bool running = true;
    while(running)
    {
        while(SDL_PollEvent(&event) != 0)
        {
            if(event.type == SDL_KEYDOWN)
            {
                if(event.key.keysym.sym == SDLK_SPACE)
                {
                    lineMode = !lineMode;
                    if(lineMode)
                        glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
                    else
                        glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
                }
                else if(event.key.keysym.sym == SDLK_ESCAPE)
                    running = false;
            }
            else if(event.type == SDL_QUIT)
                running = false;
        }

        glClear(GL_COLOR_BUFFER_BIT);
        shader.use();
        vao.bind();
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, cast(void*)0);
        vao.unbind();

        SDL_GL_SwapWindow(Screen.window);
        SDL_Delay(10);
    }
    ebo.destroy();
    vbo.destroy();
    vao.destroy();
    shader.destroy();
    cleanUp();
}
