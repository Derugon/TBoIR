attribute vec3 Position;
attribute vec2 TexCoord;
attribute vec3 ScreenSizePow2;
varying vec2 TexCoord0;
varying vec3 ScreenSizePow2Out;
uniform mat4 Transform;

void main(void)
{
	ScreenSizePow2Out = ScreenSizePow2;
	gl_Position = Transform * vec4(Position.xyz, 1.0);
	TexCoord0 = TexCoord;
}
