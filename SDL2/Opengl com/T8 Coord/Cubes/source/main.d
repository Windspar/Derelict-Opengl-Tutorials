import common.sdl.common;

// Use spacebar to flip smile
void main()
{
    if(!setupScreen("Cubes", 800, 600))
        return;

    glEnable(GL_DEPTH_TEST);

    GLuint container = loadImage("resources/container.jpg");
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    GLuint smiles = loadImage("resources/awesomeface.png");
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    GLfloat[] vertices = [
	   -0.5f, -0.5f, -0.5f,  0.0f, 0.0f,
	    0.5f, -0.5f, -0.5f,  1.0f, 0.0f,
        0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
        0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
       -0.5f,  0.5f, -0.5f,  0.0f, 1.0f,
       -0.5f, -0.5f, -0.5f,  0.0f, 0.0f,

       -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
        0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
        0.5f,  0.5f,  0.5f,  1.0f, 1.0f,
        0.5f,  0.5f,  0.5f,  1.0f, 1.0f,
       -0.5f,  0.5f,  0.5f,  0.0f, 1.0f,
       -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,

       -0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
       -0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
       -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
       -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
       -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
       -0.5f,  0.5f,  0.5f,  1.0f, 0.0f,

        0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
        0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
        0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
        0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
        0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
        0.5f,  0.5f,  0.5f,  1.0f, 0.0f,

       -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
        0.5f, -0.5f, -0.5f,  1.0f, 1.0f,
        0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
        0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
       -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
       -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,

       -0.5f,  0.5f, -0.5f,  0.0f, 1.0f,
        0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
        0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
        0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
       -0.5f,  0.5f,  0.5f,  0.0f, 0.0f,
       -0.5f,  0.5f, -0.5f,  0.0f, 1.0f
	];

	vec3[] cubePositions = [
		vec3( 0.0f,  0.0f,  0.0f),
		vec3( 2.0f,  5.0f, -15.0f),
		vec3(-1.5f, -2.2f, -2.5f),
		vec3(-3.8f, -2.0f, -12.3f),
		vec3( 2.4f, -0.4f, -3.5f),
		vec3(-1.7f,  3.0f, -7.5f),
		vec3( 1.3f, -2.0f, -2.5f),
		vec3( 1.5f,  2.0f, -2.5f),
		vec3( 1.5f,  0.2f, -1.5f),
		vec3(-1.3f,  1.0f, -1.5f)
	];

    VertexArray vao = VertexArray(1).bind();
    VertexBuffer vbo = VertexBuffer(1).bind(GL_ARRAY_BUFFER);
    vbo.data(GL_ARRAY_BUFFER, vertices.glSizeof(), vertices.ptr, GL_STATIC_DRAW);
    vao.attribute(0, 3, GL_FLOAT, GL_FALSE, 5 * GLfloat.sizeof, cast(void*)0);
    vao.attribute(1, 2, GL_FLOAT, GL_FALSE, 5 * GLfloat.sizeof, cast(void*)(3 * GLfloat.sizeof));
    vao.unbind();

    ShaderProgram shader = ShaderProgram("resources/vshader.glsl","resources/fshader.glsl");
    bool doRotation = true;

    // going 3d
    mat4 model, view, proj;
	view = mat4.identity;
	view = view.translate(0.0f, 0.0f, -3.0f);
	proj = mat4.perspective(Screen.width, Screen.height, 45.0f, 0.1f, 100.0f);

    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
    SDL_Event event;
    uint ticks = 0;
    bool running = true;
    while(running)
    {
        while(SDL_PollEvent(&event) != 0)
        {
            if(event.type == SDL_KEYDOWN)
            {
                if(event.key.keysym.sym == SDLK_SPACE)
                    doRotation = !doRotation;
                else if(event.key.keysym.sym == SDLK_ESCAPE)
                    running = false;
            }
            else if(event.type == SDL_QUIT)
                running = false;
        }

        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        shader.use();
        shader.uniformMatrix4fv("view", 1, GL_TRUE, view);
		shader.uniformMatrix4fv("proj", 1, GL_TRUE, proj);
        shader.uniform1i("texture1", 0);
        shader.uniform1i("texture2", 1);
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, container);
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, smiles);
        vao.bind();
        if(doRotation)
            ticks = SDL_GetTicks();

        foreach(uint i, vec3 position; cubePositions)
        {
            GLfloat angle = 20.0f * i;
            if(doRotation)
            {
                if(i % 3 == 0)
                    model = mat4.rotation(radians(angle + ticks * 0.05f), vec3(-1.0f, -0.3f, -0.5f));
                else
                    model = mat4.rotation(radians(angle), vec3(-1.0f, -0.3f, -0.5f));
            }
            else
                model = mat4.rotation(radians(angle), vec3(-1.0f, -0.3f, -0.5f));

            model = model.translate(position);
			shader.uniformMatrix4fv("model", 1, GL_TRUE, model);
			glDrawArrays(GL_TRIANGLES, 0, 36);
        }
        vao.unbind();

        SDL_GL_SwapWindow(Screen.window);
        SDL_Delay(10);
    }
    vbo.destroy();
    vao.destroy();
    shader.destroy();
    cleanUp();
}
