attribute vec3 Position;
attribute vec2 TexCoord;
attribute float Time;
attribute float Amount;
attribute vec4 ScreenSize;
varying vec2 TexCoord0;
varying float TimeOut;
varying float AmountOut;
varying vec4 OutScreenSize;
uniform mat4 Transform;

void main(void)
{
	TimeOut = Time;
	AmountOut = Amount;
	OutScreenSize = ScreenSize;
	gl_Position = Transform * vec4(Position.xyz, 1.0);
	TexCoord0 = TexCoord;
}
