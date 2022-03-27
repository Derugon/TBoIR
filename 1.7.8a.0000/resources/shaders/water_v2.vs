#ifndef GL_ES
#  define lowp
#endif

attribute vec3 Position;
attribute vec4 Color;
attribute vec2 TexCoord;
attribute float Time;
attribute vec3 ColorMul;
attribute vec2 CurrentDir;
attribute vec2 TextureSize;
attribute float PixelationAmount;

varying vec4 Color0;
varying vec2 TexCoord0;
varying float Time0;
varying vec3 ColorMul0;
varying vec2 CurrentDir0;
varying lowp vec2 TextureSize0;
varying lowp float PixelationAmount0;

uniform mat4 Transform;

void main()
{
	gl_Position = Transform * vec4(Position.xyz, 1.0);
	Color0 = Color;
	TexCoord0 = TexCoord;
	Time0 = Time;
	ColorMul0 = ColorMul;
	CurrentDir0 = CurrentDir;
	TextureSize0 = TextureSize;
	PixelationAmount0 = PixelationAmount;
}
