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
    if(!setupScreen("Hello Window", 800, 600))
        return;

    glfwSetFramebufferSizeCallback(Screen.window, &framebuffer_callback);
    glClearColor(0.2f, 0.3f, 0.3f, 1.0f);

    while(!glfwWindowShouldClose(Screen.window))
    {
        processInput();
        glClear(GL_COLOR_BUFFER_BIT);

        glfwPollEvents();
        glfwSwapBuffers(Screen.window);
    }

    glfwTerminate();
}
