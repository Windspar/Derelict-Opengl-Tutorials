import common.sdl.common;

void main()
{
    if(!setupScreen("First Window", 800, 600))
        return;

    glClearColor(0.1f, 0.0f, 0.0f, 1.0f);

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

        glClear(GL_COLOR_BUFFER_BIT);
        SDL_GL_SwapWindow(Screen.window);
        SDL_Delay(10);
    }
    cleanUp();
}
