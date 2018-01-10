import common.glfw.common;

extern(C) nothrow
void framebuffer_callback(GLFWwindow* window, int width, int height)
{
    glViewport(0,0,width,height);
    Screen.width = width;
    Screen.height = height;
}

void processInput()
{
    if(glfwGetKey(Screen.window, GLFW_KEY_ESCAPE) == GLFW_PRESS)
        glfwSetWindowShouldClose(Screen.window, true);
}

void main()
{
    if(!setupScreen("Colored Triangle", 800, 600))
        return;

    glfwSetFramebufferSizeCallback(Screen.window, &framebuffer_callback);

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
    while(!glfwWindowShouldClose(Screen.window))
    {
        processInput();
        glClear(GL_COLOR_BUFFER_BIT);

        shader.use();
        vao.bind();
        glDrawArrays(GL_TRIANGLES, 0, 3);
        vao.unbind();

        glfwPollEvents();
        glfwSwapBuffers(Screen.window);
    }
    
    vbo.destroy();
    vao.destroy();
    shader.destroy();
    glfwTerminate();
}
