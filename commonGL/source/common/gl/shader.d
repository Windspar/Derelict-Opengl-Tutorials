module common.gl.shader;
import common.gl.mygl;
import std.string : toStringz;
import std.stdio : writeln;
import io = std.file;
import gl3n.linalg;

struct ShaderProgram
{
    GLuint program;

    this(in string vstring, in string fstring)
    {
        string vfile, ffile;
        GLchar* vsource, fsource;
        GLchar[512] infoLog;
        GLint success;
        program = 0;
        if(io.exists(vstring) != 0)
            vfile = cast(string) io.read(vstring);
        else
        {
            writeln("File doesn't exist. ", vstring);
            return;
        }

        if(io.exists(fstring) != 0)
            ffile = cast(string) io.read(fstring);
        else
        {
            writeln("File doesn't exist. ", fstring);
            return;
        }

        vsource = cast(GLchar*) toStringz(vfile);
        fsource = cast(GLchar*) toStringz(ffile);
        GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
        glShaderSource(vertexShader, 1, &vsource, null);
        glCompileShader(vertexShader);

        glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &success);
        if(!success)
        {
            glGetShaderInfoLog(vertexShader, 512, null, infoLog.ptr);
            writeln("Error:Shader vertex ", infoLog);
        }

        GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
        glShaderSource(fragmentShader, 1, &fsource, null);
        glCompileShader(fragmentShader);

        glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &success);
        if(!success)
        {
            glGetShaderInfoLog(fragmentShader, 512, null, infoLog.ptr);
            writeln("Error:Shader fragment ", infoLog);
        }

        program = glCreateProgram();
        glAttachShader(program, vertexShader);
        glAttachShader(program, fragmentShader);
        glLinkProgram(program);
        glGetProgramiv(program, GL_LINK_STATUS, &success);
        if(!success)
        {
            glGetProgramInfoLog(program, 512, null, infoLog.ptr);
            writeln("Error:Program ", infoLog);
        }

        // clean up
        glDeleteShader(vertexShader);
        glDeleteShader(fragmentShader);
    }

    void uniform1i(in GLchar* key, GLint v0)
	{
		glUniform1i(glGetUniformLocation(this.program, key), v0);
	}

	void uniform1f(in GLchar* key, GLfloat x)
	{
		glUniform1f(glGetUniformLocation(this.program, key), x);
	}

	void uniform3f(in GLchar* key, GLfloat x, GLfloat y, GLfloat z)
	{
		GLint location = glGetUniformLocation(this.program, key);
		glUniform3f(location, x, y, z);
	}

	void uniform3f(in GLchar* key, ref vec3 value)
	{
		GLint location = glGetUniformLocation(this.program, key);
		glUniform3f(location, value.x, value.y, value.z);
	}

	void uniform4f(in GLchar* key, GLfloat r, GLfloat g, GLfloat b, GLfloat a)
	{
		GLint location = glGetUniformLocation(this.program, key);
		glUniform4f(location, r, g, b, a);
	}

    void uniformMatrix4fv(in GLchar* key, GLsizei count, GLboolean transpose, ref mat4 value)
	{
        GLint location = glGetUniformLocation(program, key);
        glUniformMatrix4fv(location, count, transpose, value.value_ptr);
	}

	void use() { glUseProgram(program); }

	void destroy() { glDeleteProgram(program); }
}
