module common.glfw.basic;
import common.gl.mygl;
import derelict.glfw3.glfw3;
import std.stdio: writeln;

struct Screen
{
    static GLFWwindow* window;
    static int width;
    static int height;
}

bool setupScreen(string title, in int width, in int height)
{
    DerelictGL3.load();
    DerelictGLFW3.load();
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

    Screen.window = glfwCreateWindow(width, height, title.ptr, null, null);
    Screen.width = width;
    Screen.height = height;

    if(Screen.window == null)
    {
        writeln("Failed to create GLFW window");
        glfwTerminate();
        return false;
    }

    glfwMakeContextCurrent(Screen.window);
    DerelictGL3.reload();

    return true;
}
