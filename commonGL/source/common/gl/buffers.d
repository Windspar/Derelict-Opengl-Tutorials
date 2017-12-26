module common.gl.buffers;
import common.gl.mygl;

struct VertexArray
{
    GLuint vao;
    GLsizei count;

    static void unbind()
    {
        glBindVertexArray(0);
    }

    this(GLsizei n)
    {
        glGenVertexArrays(n, &vao);
        count = n;
    }

    void attribute(GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, GLvoid* pointer)
    {
        glVertexAttribPointer(index, size, type, normalized, stride, pointer);
        glEnableVertexAttribArray(index);
    }

    VertexArray bind()
    {
        glBindVertexArray(vao);
        return this;
    }

    VertexArray create(GLsizei n)
    {
        glGenVertexArrays(n, &vao);
        count = n;
        return this;
    }

    void destroy()
    {
        glDeleteVertexArrays(count, &vao);
    }

    void disableAttribute(GLuint index)
    {
        glDisableVertexAttribArray(index);
    }

    void disableAllAttributes(GLuint max_index)
    {
        for(GLuint i = 0; i < max_index; i++)
            glDisableVertexAttribArray(i);
    }

    void enableAttribute(GLuint index)
    {
        glEnableVertexAttribArray(index);
    }
}

struct VertexBuffer
{
    GLuint vbo;
    GLsizei count;

    this(GLsizei n)
    {
        glGenBuffers(n, &vbo);
        count = n;
    }

    VertexBuffer bind(GLenum target)
    {
        glBindBuffer(target, vbo);
        return this;
    }

    VertexBuffer create(GLsizei n)
    {
        glGenBuffers(n, &vbo);
        count = n;
        return this;
    }

    void data(GLenum target, GLsizeiptr size, GLvoid* data, GLenum usage)
    {
        glBufferData(target, size, data, usage);
    }

    void destroy()
    {
        glDeleteBuffers(count, &vbo);
    }
}
