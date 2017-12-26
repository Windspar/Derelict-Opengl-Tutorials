import common.sdl.common;
import std.stdio : writeln;

enum Face
{
    front = 1,
    back = 2,
    left = 4,
    right = 8,
    top = 16,
    bottom = 32,
    all = 63
}

float[] createCube(in float size, in Face face, out GLuint[] elements, bool verticesOnly=false)
{
    float[3][8] array = [
    [size, size, size],       //0  + + +    right   top      front
    [-size, -size, -size],    //1  - - -    left    bottom   back
    [size, -size, -size],     //2  + - -    right   bottom   back
    [size, size, -size],      //3  + + -    right   top      back
    [-size, size, -size],     //4  - + -    left    top      back
    [-size, size, size],      //5  - + +    left    top      front
    [-size, -size, size],     //6  - - +    left    bottom   front
    [size, -size, size]];     //7  + - +    right   bottom   front

    if((face & Face.back) > 0)
        elements ~= [1,3,2,3,1,4];
    if((face & Face.front) > 0)
        elements ~= [6,7,0,0,5,6];
    if((face & Face.left) > 0)
        elements ~= [5,4,1,1,6,5];
    if((face & Face.right) > 0)
        elements ~= [0,2,3,2,0,7];
    if((face & Face.top) > 0)
        elements ~= [4,0,3,0,4,5];
    if((face & Face.bottom) > 0)
        elements ~= [1,2,7,7,6,1];

    float[] vertices;
    if(verticesOnly is false)
    {
        foreach(float[3] vertex; array)
            vertices ~= vertex;
        return vertices;
    }

    foreach(GLuint i; elements)
        vertices ~= array[i];
    return vertices;
}

void main()
{
    if(!setupScreen("My Cube", 800, 600))
        return;

    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LESS);
    glClearColor(0.0f, 0.0f, 0.2f, 1.0f);

    GLfloat[3][6] colorChoices = [[1.0f,0.0f,0.0f], [0.0f,1.0f,0.0f],
    [0.0f,0.0f,1.0f], [1.0f,0.0f,1.0f], [1.0f,1.0f,0.0f], [0.0f,0.5f,1.0f]];

    GLfloat[] cubeColors;
    for(int i = 0; i < 6; i++)
    {
        for(int j = 0; j < 6; j++)
            foreach(GLfloat color; colorChoices[i])
                cubeColors ~= color;
    }
    writeln(cubeColors.length);

    GLuint[] indices;
    GLfloat[] cubeVertices = createCube(0.6f, Face.all, indices, true);
    writeln(cubeVertices.length);

    VertexArray cubeArray = VertexArray(1).bind();
    VertexBuffer cubeBuffer = VertexBuffer(1).bind(GL_ARRAY_BUFFER);
    cubeBuffer.data(GL_ARRAY_BUFFER, cubeVertices.glSizeof(), cubeVertices.ptr, GL_STATIC_DRAW);
    cubeArray.attribute(0, 3, GL_FLOAT, GL_FALSE, 0, cast(void*)0);

    VertexBuffer colorBuffer = VertexBuffer(1).bind(GL_ARRAY_BUFFER);
    colorBuffer.data(GL_ARRAY_BUFFER, cubeColors.glSizeof(), cubeColors.ptr, GL_STATIC_DRAW);
    cubeArray.attribute(1, 3, GL_FLOAT, GL_FALSE, 0, cast(void*)0);
    cubeArray.unbind();

    ShaderProgram shader = ShaderProgram("resources/vshader.glsl", "resources/fshader.glsl");
    mat4 projection = mat4.perspective(800, 600, 45.0f, 1.0f, 100.0f);
    mat4 view = mat4.look_at(vec3(4,3,3), vec3(0,0,0), vec3(0,1,0));
    mat4 model = mat4.identity;
    mat4 mvp;
    //mat4 mvp = projection * view * model;
    uint danceLevel = 0;
    uint danceSpeed = 6000;
    uint danceNext = danceSpeed;
    uint updateSpeed = 60;
    uint updateNext = updateSpeed;

    bool lineMode = false;
    uint timevalue;
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

        timevalue = SDL_GetTicks();
        if(timevalue > danceNext)
        {
            danceNext += danceSpeed;
            danceLevel = (danceLevel + 1) % 3;
        }

        if(timevalue > updateNext)
        {
            updateNext += updateSpeed;
            if(danceLevel == 0)
                model = model.rotatex(0.1f);
            else if(danceLevel == 1)
                model = model.rotatey(0.1f);
            else if(danceLevel == 2)
                model = model.rotatez(0.1f);
        }

        mvp = projection * view * model;

        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
        shader.use();
        shader.uniformMatrix4fv("MVP", 1, GL_TRUE, mvp);
        cubeArray.bind();
        glDrawArrays(GL_TRIANGLES, 0, 36);
        cubeArray.unbind();
        SDL_GL_SwapWindow(Screen.window);
        SDL_Delay(10);
    }
    // clean up
    cubeBuffer.destroy();
    colorBuffer.destroy();
    cubeArray.destroy();
    shader.destroy();
    cleanUp();
}
