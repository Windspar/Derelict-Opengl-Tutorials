import common.glfw.common;

struct Scene
{
    static bool lineMode = false;
}

extern(C) nothrow
void framebuffer_callback(GLFWwindow* window, int width, int height)
{
    glViewport(0,0,width,height);
    Screen.width = width;
    Screen.height = height;
}

void processInput()
{
    if(glfwGetKey(Screen.window, GLFW_KEY_SPACE) == GLFW_PRESS)
    {
        Scene.lineMode = !Scene.lineMode;
        if(Scene.lineMode)
            glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
        else
            glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
    }
    else if(glfwGetKey(Screen.window, GLFW_KEY_ESCAPE) == GLFW_PRESS)
        glfwSetWindowShouldClose(Screen.window, true);
}

void main()
{
    if(!setupScreen("Colored Triangle Box", 800, 600))
        return;

    glfwSetFramebufferSizeCallback(Screen.window, &framebuffer_callback);

    GLfloat[] vertices = [
         0.5f,  0.5f, 0.0f,
         0.5f, -0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f,
        -0.5f,  0.5f, 0.0f ];

    GLint[] indices = [0,1,3, 1,2,3];

    VertexArray vao = VertexArray(1).bind();
    VertexBuffer ebo = VertexBuffer(1).bind(GL_ELEMENT_ARRAY_BUFFER);
    ebo.data(GL_ELEMENT_ARRAY_BUFFER, indices.glSizeof(), indices.ptr, GL_STATIC_DRAW);
    VertexBuffer vbo = VertexBuffer(1).bind(GL_ARRAY_BUFFER);
    vbo.data(GL_ARRAY_BUFFER, vertices.glSizeof(), vertices.ptr, GL_STATIC_DRAW);
    vao.attribute(0, 3, GL_FLOAT, GL_FALSE, 3 * GLfloat.sizeof, cast(void*)0);
    vao.unbind();

    ShaderProgram shader = ShaderProgram("resources/vshader.glsl","resources/fshader.glsl");

    glClearColor(0.1f, 0.0f, 0.0f, 1.0f);
    while(!glfwWindowShouldClose(Screen.window))
    {
        processInput();
        glClear(GL_COLOR_BUFFER_BIT);

        shader.use();
        vao.bind();
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, cast(void*)0);
        vao.unbind();

        glfwPollEvents();
        glfwSwapBuffers(Screen.window);
    }
    ebo.destroy();
    vbo.destroy();
    vao.destroy();
    shader.destroy();
    glfwTerminate();
}
