attribute vec3 Position;
attribute vec4 Color;
attribute vec2 TexCoord;
attribute float PixelationAmount;
attribute vec4 ScreenSize;
varying vec4 Color0;
varying vec2 TexCoord0;
varying float OutPixelationAmount;
varying vec4 OutScreenSize;
uniform mat4 Transform;

void main(void)
{
	OutPixelationAmount = PixelationAmount;
	OutScreenSize = ScreenSize;
	Color0 = Color;
	gl_Position = Transform * vec4(Position.xyz, 1.0);
	TexCoord0 = TexCoord;
}
