import common.sdl.common;

void main()
{
    if(!setupScreen("Color Cube", 800, 600))
        return;

    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LESS);

    glClearColor(0.0f, 0.0f, 0.4f, 1.0f);
    ShaderProgram programID = ShaderProgram("resources/simplevertexshader.glsl", "resources/simplefragmentshader.glsl");
    GLfloat[] cubeVertexData = [
		-1.0f,-1.0f,-1.0f,
		-1.0f,-1.0f, 1.0f,
		-1.0f, 1.0f, 1.0f,
		 1.0f, 1.0f,-1.0f,
		-1.0f,-1.0f,-1.0f,
		-1.0f, 1.0f,-1.0f,
		 1.0f,-1.0f, 1.0f,
		-1.0f,-1.0f,-1.0f,
		 1.0f,-1.0f,-1.0f,
		 1.0f, 1.0f,-1.0f,
		 1.0f,-1.0f,-1.0f,
		-1.0f,-1.0f,-1.0f,
		-1.0f,-1.0f,-1.0f,
		-1.0f, 1.0f, 1.0f,
		-1.0f, 1.0f,-1.0f,
		 1.0f,-1.0f, 1.0f,
		-1.0f,-1.0f, 1.0f,
		-1.0f,-1.0f,-1.0f,
		-1.0f, 1.0f, 1.0f,
		-1.0f,-1.0f, 1.0f,
		 1.0f,-1.0f, 1.0f,
		 1.0f, 1.0f, 1.0f,
		 1.0f,-1.0f,-1.0f,
		 1.0f, 1.0f,-1.0f,
		 1.0f,-1.0f,-1.0f,
		 1.0f, 1.0f, 1.0f,
		 1.0f,-1.0f, 1.0f,
		 1.0f, 1.0f, 1.0f,
		 1.0f, 1.0f,-1.0f,
		-1.0f, 1.0f,-1.0f,
		 1.0f, 1.0f, 1.0f,
		-1.0f, 1.0f,-1.0f,
		-1.0f, 1.0f, 1.0f,
		 1.0f, 1.0f, 1.0f,
		-1.0f, 1.0f, 1.0f,
		 1.0f,-1.0f, 1.0f
	];

	GLfloat[] cubeColorData = [
		0.583f,  0.771f,  0.014f,
		0.609f,  0.115f,  0.436f,
		0.327f,  0.483f,  0.844f,
		0.822f,  0.569f,  0.201f,
		0.435f,  0.602f,  0.223f,
		0.310f,  0.747f,  0.185f,
		0.597f,  0.770f,  0.761f,
		0.559f,  0.436f,  0.730f,
		0.359f,  0.583f,  0.152f,
		0.483f,  0.596f,  0.789f,
		0.559f,  0.861f,  0.639f,
		0.195f,  0.548f,  0.859f,
		0.014f,  0.184f,  0.576f,
		0.771f,  0.328f,  0.970f,
		0.406f,  0.615f,  0.116f,
		0.676f,  0.977f,  0.133f,
		0.971f,  0.572f,  0.833f,
		0.140f,  0.616f,  0.489f,
		0.997f,  0.513f,  0.064f,
		0.945f,  0.719f,  0.592f,
		0.543f,  0.021f,  0.978f,
		0.279f,  0.317f,  0.505f,
		0.167f,  0.620f,  0.077f,
		0.347f,  0.857f,  0.137f,
		0.055f,  0.953f,  0.042f,
		0.714f,  0.505f,  0.345f,
		0.783f,  0.290f,  0.734f,
		0.722f,  0.645f,  0.174f,
		0.302f,  0.455f,  0.848f,
		0.225f,  0.587f,  0.040f,
		0.517f,  0.713f,  0.338f,
		0.053f,  0.959f,  0.120f,
		0.393f,  0.621f,  0.362f,
		0.673f,  0.211f,  0.457f,
		0.820f,  0.883f,  0.371f,
		0.982f,  0.099f,  0.879f
	];

    VertexArray vertexArray = VertexArray(1).bind();
    VertexBuffer vertexBuffer = VertexBuffer(1).bind(GL_ARRAY_BUFFER);
    vertexBuffer.data(GL_ARRAY_BUFFER, cubeVertexData.glSizeof(), cubeVertexData.ptr, GL_STATIC_DRAW);
    vertexArray.attribute(0, 3, GL_FLOAT, GL_FALSE, 0, cast(void*)0);

    VertexBuffer colorBuffer = VertexBuffer(1).bind(GL_ARRAY_BUFFER);
    colorBuffer.data(GL_ARRAY_BUFFER, cubeColorData.glSizeof(), cubeColorData.ptr, GL_STATIC_DRAW);
    vertexArray.attribute(1, 3, GL_FLOAT, GL_FALSE, 0, cast(void*)0);
    vertexArray.unbind();

    mat4 projection = mat4.perspective(800, 600, 45.0f, 0.1f, 100.0f);
    mat4 view = mat4.look_at(
            vec3(4,3,3),
            vec3(0,0,0),
            vec3(0,1,0));
    mat4 model = mat4.identity;
    mat4 mvp = projection * view * model;

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
        programID.uniformMatrix4fv("MVP", 1, GL_TRUE, mvp);
        vertexArray.bind();
        glDrawArrays(GL_TRIANGLES, 0, 36);
        vertexArray.unbind();
        SDL_GL_SwapWindow(Screen.window);
        SDL_Delay(10);
    }
    // clean up
    vertexBuffer.destroy();
    colorBuffer.destroy();
    vertexArray.destroy();
    programID.destroy();
    cleanUp();
}
