module common.sdl.basic;
import common.gl.mygl;
import std.stdio : writeln;
import derelict.sdl2.sdl;
import derelict.sdl2.image;

struct Screen
{
    static int width;
    static int height;
    static SDL_Window* window;
    static SDL_GLContext context;
}

bool setupScreen(string title, in int width, in int height, SDL_WindowFlags flags=SDL_WINDOW_OPENGL)
{
    Screen.width = width;
    Screen.height = height;
    DerelictGL3.load();
    DerelictSDL2.load();
    if(SDL_Init(SDL_INIT_EVERYTHING) == -1)
    {
        writeln("Failed to init sdl2! ", SDL_GetError());
        return false;
    }

    SDL_GL_SetAttribute(SDL_GL_RED_SIZE, 8);
	SDL_GL_SetAttribute(SDL_GL_GREEN_SIZE, 8);
	SDL_GL_SetAttribute(SDL_GL_BLUE_SIZE, 8);
	SDL_GL_SetAttribute(SDL_GL_ALPHA_SIZE, 8);
	SDL_GL_SetAttribute(SDL_GL_BUFFER_SIZE, 32);
	SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
	SDL_GL_SetAttribute(SDL_GL_MULTISAMPLEBUFFERS, 1);
	SDL_GL_SetAttribute(SDL_GL_MULTISAMPLESAMPLES, 4);

    int undefined = cast(int) SDL_WINDOWPOS_UNDEFINED;
    Screen.window = SDL_CreateWindow(title.ptr, undefined, undefined,
         Screen.width, Screen.height, flags);
    if(!Screen.window)
    {
        writeln("Unable to make sdl2 window! ", SDL_GetError());
        return false;
    }

    Screen.context = SDL_GL_CreateContext(Screen.window);
    if(!Screen.context)
    {
        writeln("Couldn't create opengl context! ", SDL_GetError());
        SDL_DestroyWindow(Screen.window);
        return false;
    }

    DerelictGL3.reload();
    if(SDL_GL_SetSwapInterval(1) < 0)
        writeln("Unable to vsync! ", SDL_GetError());

    DerelictSDL2Image.load();
    IMG_Init(7);

    return true;
}

void cleanUp()
{
    SDL_GL_DeleteContext(Screen.context);
    SDL_DestroyWindow(Screen.window);
    IMG_Quit();
    SDL_Quit();
}
