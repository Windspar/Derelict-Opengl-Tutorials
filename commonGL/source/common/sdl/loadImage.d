module common.sdl.loadImage;
import derelict.sdl2.sdl;
import derelict.sdl2.image;
import common.gl.mygl;
import std.stdio;

// callbacks is to set glTexParameter
GLuint loadImage(in string filename,
    void function() fCall=null,
    void delegate() dCall=null)
{
    GLuint texture;
    SDL_Surface* surface = IMG_Load(filename.ptr);
    if(!surface)
    {
        writeln("Unable to load image ", filename, ".");
        return 0;
    }

    GLenum iformat, format;
    if(surface.format.BytesPerPixel == 3)
    {
        iformat = GL_RGB;
        if(surface.format.Rmask == 0xff)
            format = GL_RGB;
        else
            format = GL_BGR;
    }
    else if(surface.format.BytesPerPixel == 4)
    {
        iformat = GL_RGBA;
        if(surface.format.Rmask == 0xff)
            format = GL_RGBA;
        else
            format = GL_BGRA;
    }
    else
    {
        writeln("Unknown image format ", filename, ". BytesPerPixel is ", surface.format.BytesPerPixel);
        SDL_FreeSurface(surface);
        return 0;
    }

    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexImage2D(GL_TEXTURE_2D, 0, iformat, surface.w, surface.h, 0, format, GL_UNSIGNED_BYTE, surface.pixels);

    if(fCall != null)
        fCall();

    if(dCall != null)
        dCall();

    SDL_FreeSurface(surface);
    return texture;
}
