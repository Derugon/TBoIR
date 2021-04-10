attribute vec3 Position;
attribute vec4 Color;
attribute vec2 TexCoord;
attribute vec4 Ratio;
attribute float Amount;
attribute float PixelationAmount;

varying vec4 Color0;
varying vec2 TexCoord0;
varying vec4 Ratio0;
varying lowp float Amount0;
varying lowp float PixelationAmount0;

uniform mat4 Transform;

void main()
{
	gl_Position = Transform * vec4(Position.xyz, 1.0);
	Color0 = Color;
	TexCoord0 = TexCoord;
	Ratio0 = Ratio;
	Amount0 = Amount;
	PixelationAmount0 = PixelationAmount;
}
