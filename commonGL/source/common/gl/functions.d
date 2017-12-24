module common.gl.functions;

uint glSizeof(T)(in T[] array)
{
    return cast(uint) (array.length * T.sizeof);
}
