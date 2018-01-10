import common.sdl.common;

// Use spacebar to flip smile
void main()
{
    if(!setupScreen("BookShelf Smiles", 800, 600))
        return;

    GLuint container = loadImage("resources/container.jpg");
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    GLuint smiles = loadImage("resources/awesomeface.png");
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    float[] vertices = [
         0.5f,  0.5f, 0.0f,   1.0f, 0.0f, 0.0f,   1.0f, 1.0f,
         0.5f, -0.5f, 0.0f,   0.0f, 1.0f, 0.0f,   1.0f, 0.0f,
        -0.5f, -0.5f, 0.0f,   0.0f, 0.0f, 1.0f,   0.0f, 0.0f,
        -0.5f,  0.5f, 0.0f,   1.0f, 1.0f, 0.0f,   0.0f, 1.0f ];

    GLint[] indices = [0,1,3, 1,2,3];

    VertexArray vao = VertexArray(1).bind();
    VertexBuffer ebo = VertexBuffer(1).bind(GL_ELEMENT_ARRAY_BUFFER);
    ebo.data(GL_ELEMENT_ARRAY_BUFFER, indices.glSizeof(), indices.ptr, GL_STATIC_DRAW);
    VertexBuffer vbo = VertexBuffer(1).bind(GL_ARRAY_BUFFER);
    vbo.data(GL_ARRAY_BUFFER, vertices.glSizeof(), vertices.ptr, GL_STATIC_DRAW);
    vao.attribute(0, 3, GL_FLOAT, GL_FALSE, 8 * GLfloat.sizeof, cast(void*)0);
    vao.attribute(1, 3, GL_FLOAT, GL_FALSE, 8 * GLfloat.sizeof, cast(void*)(3 * GLfloat.sizeof));
    vao.attribute(2, 2, GL_FLOAT, GL_FALSE, 8 * GLfloat.sizeof, cast(void*)(6 * GLfloat.sizeof));
    vao.unbind();

    ShaderProgram shader = ShaderProgram("resources/vshader.glsl","resources/fshader.glsl");
    bool doFlip = true;

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
                    doFlip = !doFlip;
                else if(event.key.keysym.sym == SDLK_ESCAPE)
                    running = false;
            }
            else if(event.type == SDL_QUIT)
                running = false;
        }

        glClear(GL_COLOR_BUFFER_BIT);
        shader.use();
        shader.uniform1i("doFlip", doFlip);
        shader.uniform1i("texture1", 0);
        shader.uniform1i("texture2", 1);
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, container);
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, smiles);
        vao.bind();
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, cast(void*)0);
        vao.unbind();

        SDL_GL_SwapWindow(Screen.window);
        SDL_Delay(10);
    }
    vbo.destroy();
    shader.destroy();
    cleanUp();
}
