attribute vec3 Position;
attribute vec4 Color;
attribute vec2 TexCoord;
attribute vec2 TextureSize;
attribute vec4 Ratio;
attribute float Time;
attribute float Amount;
attribute float PixelationAmount;

varying vec4 Color0;
varying vec2 TexCoord0;
varying vec2 TextureSize0;
varying vec4 Ratio0;
varying lowp float Time0;
varying lowp float Amount0;
varying lowp float PixelationAmount0;

uniform mat4 Transform;

void main()
{
	gl_Position = Transform * vec4(Position.xyz, 1.0);
	Color0 = Color;
	TexCoord0 = TexCoord;
	TextureSize0 = TextureSize;
	Ratio0 = Ratio;
	Time0 = Time;
	Amount0 = Amount;
	PixelationAmount0 = PixelationAmount;
}
