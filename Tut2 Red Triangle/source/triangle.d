import common.sdl.common;

void main()
{
    if(!setupScreen("Red Triangle", 800, 600))
        return;

    glClearColor(0.0f, 0.0f, 0.4f, 1.0f);
    ShaderProgram programID = ShaderProgram("resources/simplevertexshader.glsl", "resources/simplefragmentshader.glsl");
    GLfloat[] vertexBufferData = [
        -1.0f, -1.0f, 0.0f,
         1.0f, -1.0f, 0.0f,
         0.0f,  1.0f, 0.0f,
    ];

    VertexArray vertexArray = VertexArray(1).bind();
    VertexBuffer vertexBuffer = VertexBuffer(1).bind(GL_ARRAY_BUFFER);
    vertexBuffer.data(GL_ARRAY_BUFFER, vertexBufferData.glSizeof(), vertexBufferData.ptr, GL_STATIC_DRAW);
    vertexArray.attribute(0, 3, GL_FLOAT, GL_FALSE, 0, cast(void*)0);
    glBindVertexArray(0);

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

        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        programID.use();
        vertexArray.bind();
        glDrawArrays(GL_TRIANGLES, 0, 3);
        VertexArray.bindZero();
        SDL_GL_SwapWindow(Screen.window);
        SDL_Delay(10);
    }
    // clean up
    vertexBuffer.destroy();
    vertexArray.destroy();
    programID.destroy();
    cleanUp();
}
